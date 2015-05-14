class Hash
  def deep_reject(&block)
    self.each_with_object({}) do |(k, v), result|
      unless block.call(k, v)
        if v.is_a?(Hash)
          result[k] = v.deep_reject(&block)
        elsif v.is_a?(Array)
          result[k] = v.deep_reject(&block)
        else
          result[k] = v
        end
      end
    end
  end
end
