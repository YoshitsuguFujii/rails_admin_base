$ ->
  dispAlertMessage = (messages) ->
    if JST && JST["alert_messages"]
      $('.alert_area').html(JST["alert_messages"](messages))
    else
      html = ""
      $.each messages, (message) ->
        html = "<div class=\"alert alert-{{../type}}\">
                  #{message}
                </div>"
      $('.alert_area').html($("<div>").text(html).html())

  commonAjaxRequest = (url, method = "PUT", send_data = {})->
    dfd = $.Deferred()
    $.ajax url,
      type: method,
      data: send_data,
      dataType: "json"
      beforeSend: ->
        dispAlertMessage({})
      success: (message) ->
        dispAlertMessage(message) if message.messages
        dfd.resolve()
      error: (XMLHttpRequest, textStatus, errorThrown)=>
        message = {type: 'danger', messages: ['処理に失敗しました。再度実行してください。']}
        dispAlertMessage(message)
        dfd.reject()

  $(document).on "click", ".bootbox-ajax-form", (event)->
    event.preventDefault() if event

    if bootbox
      url = $(@).data("url")
      send_data =
        call_from: "bootbox-ajax-request"
      init_callback_function = $(@).data("initCallbackFunction")
      callback_function = $(@).data("callbackFunction")

      dfd = commonAjaxRequest(url, "GET", send_data)
      dfd.done (data) =>
        bootboxModal = bootbox.dialog
          title: ""
          message: data.html
          buttons:
            success:
              label: "登録"
              className: "btn btn-register btn-success"
              callback: ->
                $form = $(@).find("form")
                url = $form.prop("action")
                method = $form.prop("method")

                dfd_post = commonAjaxRequest(url, method, $form.serializeArray())
                dfd_post.done (data) ->
                  if data.type == "success"
                    bootbox.hideAll()
                    eval(callback_function) if callback_function
                  else
                    $(".bootbox-body").html(data.html)
                # 自動で閉じさせない
                return false
        bootboxModal.on "shown.bs.modal", ->
          eval(init_callback_function) if init_callback_function
        bootboxModal.modal('show')


  $(document).on "click", ".bootbox-ajax-preview", (event)->
    event.preventDefault() if event

    if bootbox
      url = $(@).data("url")
      init_callback_function = $(@).data("initCallbackFunction")
      callback_function = $(@).data("callbackFunction")

      send_data = _.reject $(@).closest("form").serializeArray(), (data)->
        _.include(["_method"], data.name)

      dfd = commonAjaxRequest(url, "POST", send_data)
      dfd.done (data) =>
        bootboxModal = bootbox.dialog
          title: ""
          message: data.html
          buttons:
            success:
              label: "閉じる"
              className: "btn btn-register btn-default"
              callback: ->
                eval(callback_function) if callback_function
        bootboxModal.on "shown.bs.modal", ->
          eval(init_callback_function) if init_callback_function
        bootboxModal.modal('show')
