module RailsAdminBase::Refinements
  module StringEx
    refine String do
      def numeric?
        (self.to_s =~ /^\d+$/).present?
      end

      def has_alphabet?
        !!(Regexp.new(/[a-zA-Z]/) =~ self.to_s)
      end

      def has_numeric?
        !!(Regexp.new(/[0-9]/) =~ self.to_s)
      end

      def to_b
        self == "true"
      end
    end
  end
end
