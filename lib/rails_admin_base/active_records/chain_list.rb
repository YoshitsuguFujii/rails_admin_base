module RailsAdminBase::ActiveRecord
  module ChainList
    extend ActiveSupport::Concern

    module ClassMethods
      def chainable(column= "id")
        class_eval <<-EOV, __FILE__, __LINE__ + 1
          def next(*args)
            self.class.where(self.class.arel_table["#{column}"].gt(send("#{column}"))).order(#{column}: :asc).first
          end

          def prev(*args)
            self.class.where(self.class.arel_table["#{column}"].lt(send("#{column}"))).order(#{column}: :asc).first
          end
        EOV
      end
    end
  end
end
