module RailsAdminBase::Refinements
  module ActiveRecordEx
    refine ActiveRecord::Base do
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
    end
  end
end
