# Sass::Engineを使った簡易的なチェック
class CssValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    begin
      Sass::Engine.new(value, syntax: :scss, style: :expand, cache: false).to_css
    rescue Sass::SyntaxError => ex
      object.errors[attribute] << (options[:messge] || I18n.t('errors.messages.css_syntax_error'))
    rescue Encoding::UndefinedConversionError => ex
      object.errors[attribute] << (options[:messge] || I18n.t('errors.messages.css_encoding_utf8_error'))
    rescue Encoding::UndefinedConversionError => ex
      object.errors[attribute] << (options[:messge] || I18n.t('errors.messages.css_encoding_error'))
    rescue => ex
      object.errors[attribute] << (options[:messge] || ex.message)
    end
  end
end
