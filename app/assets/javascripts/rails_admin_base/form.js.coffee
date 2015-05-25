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
