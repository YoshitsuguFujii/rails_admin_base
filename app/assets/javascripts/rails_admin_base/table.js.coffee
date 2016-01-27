$ ->
  clickableClassName = 'clickable'
  $(document).on "click", ".#{clickableClassName}" , (event) ->
    if !$(event.target).is('a') && !$(event.target).is('select')
      window.location = $(event.target).closest('tr').data('href')
