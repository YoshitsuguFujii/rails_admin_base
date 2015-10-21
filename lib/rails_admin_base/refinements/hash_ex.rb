module RailsAdminBase::Refinements
  module HashEx
    refine Hash do
      def different_values_key(hash)
        keys = []
        me = self.with_indifferent_access
        hash = hash.with_indifferent_access
        me.keys.each do |key|
          next unless hash.has_key?(key)
          keys << key unless hash[key] == me[key]
        end
        keys
      end
    end
  end
end
