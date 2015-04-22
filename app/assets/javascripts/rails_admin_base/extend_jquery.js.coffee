$ ->
  jQuery.extend jQuery.fn,
    toggle_value: ->
      obj = jQuery(this)
      obj.val ((if obj.val() is "true" then "false" else "true"))
    exists: ->
      @length > 0
    enable: ->
      $(this).removeAttr "disabled"
    disabled: ->
      $(this).attr "disabled", "disabled"
    member: (str) ->
      $(this).html().indexOf(str) isnt -1
    checked: (str) ->
      $(this).attr "checked"
    check: (str) ->
      $(this).attr "checked", "checked"
    uncheck: (str) ->
      $(this).removeAttr "checked"
    only_one_inputable: ->
      $(@).bind "change", ->
        entered_input = null
        $(@).find("input").each ->
          $(@).disabled()
          if $(@).val() != ''
            entered_input = $(@)

        if entered_input
          entered_input.enable()
        else
          $(@).find("input").each ->
            $(@).enable()
    clear_input: ->
      $(@).find("textarea, :text, select").val("").end().find(":checked").prop("checked", false)
    clear_text_input: ->
      $(@).find("textarea, :text").val("").end()
    check_radio_first: ->
      $(@).find("input:radio:first").prop("checked", true)
    exists_text_val: ->
      vals = _.map $(@).find("textarea, :text"), (elem) ->
        return $(elem).val()
      console.log(vals)
      not _.isEmpty(_.compact(vals))
    serializeHash: ->
      attrs = {}
      _.each $(@).serializeArray(), (field) ->
        attrs[field.name] = field.value
      attrs

