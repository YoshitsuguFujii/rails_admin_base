module RailsAdminBase::ActiveRecord
  module Position
    class GetMissingNumberFailer  < StandardError;end

    def get_missing_number(table_name: nil, target_column_name: nil)
      table_name ||= self.class.table_name
      sql = <<-"SQL_EOS".strip_heredoc
        SELECT
            MIN( #{target_column_name} + 1 ) AS #{target_column_name}
        FROM
          #{table_name}
        WHERE
            (#{target_column_name} + 1) NOT IN (SELECT #{target_column_name} FROM #{table_name})
      SQL_EOS

      results = self.class.find_by_sql(sql)

      if results.size != 1
        raise GetMissingNumberFailer
      end

      results.first[target_column_name].to_i
    end

    def renumbering(table_name: nil, target_column_name: nil)
      # 自動整列
      table_name ||= self.class.table_name
      target_column_name ||= "position"
      sql = <<-"SQL_EOS".strip_heredoc
          update #{table_name}
            inner join
              ( select * from
                (
                  select @i:=@i+1 as rownum,id,#{target_column_name} from (select @i:=0) as dummy, #{table_name}
                  order by #{target_column_name}
                ) as auto_numbering
              ) as row_number
            on
              #{table_name}.id = row_number.id
           set #{table_name}.#{target_column_name} = row_number.rownum
      SQL_EOS

      ActiveRecord::Base.connection.execute(sql)
    end

    def get_missing_number_from_numbering_scope_constant(target_column_name: 'position')
      placeholder, where_value = get_where_and_assign_value

      sql = <<-"SQL_EOS".strip_heredoc
          SELECT
            MIN( #{target_column_name} + 1 ) AS #{target_column_name}
          FROM
            #{self.class.table_name}
          WHERE
              #{where_value} AND
              (#{target_column_name} + 1) NOT IN (SELECT #{target_column_name} FROM #{self.class.table_name} where #{where_value})
        SQL_EOS

      sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, placeholder])
      results = self.class.find_by_sql(sql)

      raise GetMissingNumberFailer if results.size != 1

      results.first[target_column_name].to_i
    end

    def renumbering_from_numbering_scope_constant(target_column_name: 'position')
      placeholder, where_value = get_where_and_assign_value

      where_value = "where (#{where_value})" if where_value.present?

      # 自動整列
      sql = <<-"SQL_EOS".strip_heredoc
          update #{self.class.table_name}
            inner join
              ( select * from
                (
                  select @i:=@i+1 as rownum,id,#{target_column_name} from (select @i:=0) as dummy, #{self.class.table_name}
                  #{where_value}
                  order by #{target_column_name}
                ) as auto_numbering
              ) as row_number
            on
              #{self.class.table_name}.id = row_number.id
           set #{self.class.table_name}.#{target_column_name} = row_number.rownum
      SQL_EOS

      sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, placeholder])
      ActiveRecord::Base.connection.execute(sql)
    end

    def get_where_and_assign_value
      placeholder = {}
      where_values  = []
      self.class::NUMBERING_SCOPE.each do |scope|
        where_values << "`#{self.class.table_name}`.`#{scope}` = :#{scope}"
        placeholder[scope] = send(scope)
      end
      where_value = where_values.join(' AND ')
      [placeholder, where_value]
    end
  end
end
