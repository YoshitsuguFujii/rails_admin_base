$ ->
  $(document).on "click", ".paginate-list-loading a", (event)->
    template = '<div class="loading"></div>'
    label = "<div class='space-h40'></div><div class='text-center'>" + template + "</div>"
    $(".list").html(label)
