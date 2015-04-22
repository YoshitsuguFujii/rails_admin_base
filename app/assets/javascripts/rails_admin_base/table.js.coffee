$ ->
  clickableClassName = 'clickable'
  $(document).on "click", ".#{clickableClassName}" , (event) ->
    if !$(event.target).is('a')
      window.location = $(event.target).closest('tr').data('href')
