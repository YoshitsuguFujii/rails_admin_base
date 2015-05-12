module RailsAdminBase
  module ApplicationHelper
    def make_search_date_field(f, target)
      html = ""
      html << f.input_field(target.to_sym, as: :date, required: false, include_blank: true, :date_separator => "/ ", class: 'form-control bootstrap-date')
      return html.html_safe
    end

    # 前月＋今月＋本日＋クリアボタン作成
    def date_btn
      html = ""
      html << link_to("前月","javascript:void(0)", class:   "btn btn-primary search_prev_month") + " "
      html << link_to("今月","javascript:void(0)", class:   "btn btn-primary search_this_month") + " "
      html << link_to("本日","javascript:void(0)", class:   "btn btn-primary search_today") + " "
      html << link_to("クリア","javascript:void(0)", class: "btn btn-primary search_clear") + " "
      html.html_safe
    end

    # 日時の検索用(フルセット)
    def make_datetime_search_field(f,label_name,target)
      content_tag(:div,
        label_name.html_safe + " " + make_search_date_field(f, "#{target}_gteq".to_sym) + " - " + make_search_date_field(f, "#{target}_lteq".to_sym) + date_btn,
        class: "row search_row"
      )
    end

    def options_for_select_from_enum(klass, target)
      enum_list = klass.send("#{target.to_s}s")
      enum_list.map do |key, _value|
        [klass.human_attribute_name(key), key]
      end
    end

    def options_for_select_from_enum_number(klass, target)
      enum_list = klass.send("#{target.to_s}s")
      enum_list.keys.map{|key| klass.human_attribute_name(key)}.zip(enum_list.values)
    end
  end
end
