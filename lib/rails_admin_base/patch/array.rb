class Array
  def deep_reject(&block)
    self.each_with_object([]) do |v, result|
      unless block.call(v)
        if v.is_a?(Array)
          result << v.deep_reject(&block)
        elsif v.is_a?(Hash)
          result << v.deep_reject(&block)
        else
          result << v
        end
      end
    end
  end
end
