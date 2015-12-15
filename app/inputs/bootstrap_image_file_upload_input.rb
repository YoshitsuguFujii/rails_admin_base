class BootstrapImageFileUploadInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    merged_input_options.merge!({"data-browse-label": t("browse").html_safe})
    merged_input_options.merge!({"data-caption-class": "form-control col-xs-2"})
    merged_input_options.merge!({"data-main-class": "col-sm-offset-2"})
    merged_input_options.merge!({"data-show-upload": "false"})
    merged_input_options.merge!({"data-max-file-count": "1"})
    merged_input_options.merge!({"data-show-preview": "true"})
    merged_input_options.merge!({"data-browse-class": "btn btn-info fileinput-browse-button"})
    merged_input_options.merge!({"data-browse-icon": "<i class='glyphicon glyphicon-folder-open'></i> &nbsp;".html_safe})
    merged_input_options.merge!({"data-remove-icon": "<i class='glyphicon glyphicon-trash'></i> &nbsp;".html_safe})
    merged_input_options.merge!({"data-remove-label": t("remove-label").html_safe})
    merged_input_options.merge!({"data-remove-class": "btn btn-warning"})

    if options[:preview_image].present?
      image = "<img src='#{options[:preview_image]}' class='file-preview-image'>"
      merged_input_options.merge!({"data-initial-preview": image})

      caption = URI.parse(options[:preview_image]).path.split("/").last
      merged_input_options.merge!({"data-initial-caption": caption})
    end

    @builder.file_field(attribute_name, merged_input_options).html_safe +
    @builder.hidden_field("remove_#{attribute_name}", class: "remove_image").html_safe
  end
end
