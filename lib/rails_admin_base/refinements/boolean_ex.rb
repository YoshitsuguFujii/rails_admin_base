module RailsAdminBase::Refinements
  module BooleanEx
    refine TrueClass do
      def true.to_circle
        "<i class='fa  fa-circle-o'></i>".html_safe
      end
    end

    refine FalseClass do
      def false.to_circle
        ""
      end
    end
  end
end
