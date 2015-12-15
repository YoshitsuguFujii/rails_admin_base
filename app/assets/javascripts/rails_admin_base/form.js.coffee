$ ->
  # 文字数表示
  $(document).on "keyup", ".count_char", (event)->
    str = ""
    if $(@).data("maxCount")
      str = " / #{$(@).data("maxCount")}"

    length = $(@).val().length
    str = length + str
    $(@).next().html(str)

  $.each $(".count_char"), ->
    if $(@).next()
      $(@).after("<span class=\"char_counter\">0</span>")
  $(".count_char").trigger('keyup')

  $(document).on 'fileimageloaded', '.bootstrap_image_file_upload', (event, previewId) ->
    file_input = @
    fd = new FormData($('form').get(0));
    fd.append('paramsKey', $('form').data("paramsKey"))
    $.ajax({
      url: "/rails_engine_base/upload_file/tmp_upload",
      type: "POST",
      data: fd,
      processData: false,
      contentType: false,
      dataType: 'json',
      context: file_input
    })
    .done ( data ) ->
      $(@).closest(".form-group").find('img').data("tempFile", _.values(data[0])[0])

  $(document).on 'click', '.fileinput-remove-button', (event, previewId) ->
    $(@).parents(".bootstrap_image_file_upload").find(".remove_image").val(1)

  class MultiSelectWithoutCtrl
    constructor: (_this, options)->
      @url = options.url
      @selectable = $(_this)
      @belongs =  $("#{options.belongs_name}")
      @target = $("#{options.target_name}")
      @when_select()
      @belongs.trigger("change", {})
      @all_select()
    when_select: ->
      @belongs.on "change", (event, args) =>
        if @belongs.val() && @belongs.val() != "0"
          id = @belongs.val()
          dfd = Rab.commonAjaxRequest(@url.replace(":id",  id), "GET")
          dfd.done (data) =>
            if data.length > 0
              @selectable.enable()
              @selectable.html(JST["options"](data))
              @delete_uniq_options()
            else
              @clear_options()
        else
          @clear_options()

      @target.on "click" , (event) =>
        event.preventDefault()
        options = $(event.currentTarget).find("option:selected")
        @selectable.append(options)
        @all_select()
      @selectable.on "click" , (event) =>
        event.preventDefault()
        options = $(event.currentTarget).find("option:selected")
        @target.append(options)
        @all_select()
    clear_options: ->
      @selectable.html("")
      @selectable.disabled()
    delete_uniq_options: ->
      selected_ids = _.pluck(@target.find("option"), 'value');
      _.each @selectable.find("option"), (option) ->
        if _.include(selected_ids, option.value)
          option.remove()
    all_select: ->
      @target.find("option").prop("selected", true)


  $.fn.multiSelectWithoutCtrl = (options) ->
    new MultiSelectWithoutCtrl(@, options)
