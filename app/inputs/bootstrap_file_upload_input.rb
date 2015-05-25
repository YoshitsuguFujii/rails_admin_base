class BootstrapFileUploadInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    html = ""
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    if options[:input_html] && options[:input_html][:value].present?
      caption = options[:input_html][:value]
      merged_input_options.merge!({"data-initial-caption": caption})
    end

    html << @builder.file_field(attribute_name, merged_input_options).html_safe
  end
end
