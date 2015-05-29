$ ->
  # 表示
  $(document).on "click", ".bootbox-ajax-form", (event)->
    event.preventDefault() if event

    if bootbox
      url = $(@).data("url")
      send_data =
        call_from: "bootbox-ajax-request"
      init_callback_function = $(@).data("initCallbackFunction")
      callback_function = $(@).data("callbackFunction")

      dfd = Rab.commonAjaxRequest(url, "GET", send_data)
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

                dfd_post = Rab.commonAjaxRequest(url, method, $form.serializeArray())
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


  # プレビュー
  $(document).on "click", ".bootbox-ajax-preview", (event)->
    event.preventDefault() if event

    if bootbox
      url = $(@).data("url")
      init_callback_function = $(@).data("initCallbackFunction")
      callback_function = $(@).data("callbackFunction")

      images = []
      $.each $(@).closest("form").find("img"), (idx) ->
        if $(@).data("tempFile")
          images.push({name: "image[]", value: $(@).data("tempFile")})
        else
          images.push({name: "image[]", value: @src})

      send_data = _.reject $(@).closest("form").serializeArray(), (data)->
        _.include(["_method"], data.name)
      send_data = send_data.concat(images)

      dfd = Rab.commonAjaxRequest(url, "POST", send_data)
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

  # 削除確認
  $(document).on "click", ".delete-confirm", (event)->
    messege = $(@).data("confirmMessage")
    unless messege
      messege = "Are you sure?"
    confirm = bootbox.confirm messege, (result) =>

      if result is true
        if $(@).data("remote")
          url = $(@).siblings(".delete-link").attr("href")
          dfd = Rab.commonAjaxRequest(url, "DELETE")
          dfd.done (data) =>
            if (data.status != 200 && $(".return-message").exists())
              $(".return-message").html("<div class='alert alert-danger mr30 ml30'>#{data.message}</div>")
            else
              $deleted_elem = $("[data-id=#{data.id}]")
              if $deleted_elem.exists
                $deleted_elem.find(".btn-inline").html("<div class='pb10 pt10'>[×]削除しました</div>")

            console.log("bbbb")
        else
          $(@).siblings(".delete-link").trigger("click")
      return
