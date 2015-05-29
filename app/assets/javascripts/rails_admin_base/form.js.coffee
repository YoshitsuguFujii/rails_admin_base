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
