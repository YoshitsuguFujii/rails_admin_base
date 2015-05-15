$ ->
  # ファイルアップロード
  $(document).on "click", ".rab_upload_file", (event) ->
    event.preventDefault() if event

    if bootbox
      url = $(@).data("url")
      template = $(@).data("template") ||
             "<form enctype='multipart/form-data' action='#{url}' accept-charset='UTF-8' method='post' target='ajaxPostFile' id='rab_upload_file_form'>\n" +
             "  <div id='rab-loading-image' class='error-text mb10'></div>\n" +
             "  <div id='rab-return-error-message' class='error-text mb10'></div>\n" +
             "  <div id='rab-return-success-message' class='success-text mb10'></div>\n" +
             "  <input name='utf8' type='hidden' value='✓'>\n" +
             "  <input type='hidden' name='authenticity_token' value='#{Rab.csrfParams().authenticity_token}'>\n" +
             "  <input type='file' name='file_name' id='rab_file_name'>\n" +
             "</form>\n"

      bootboxModal = bootbox.dialog
        title: "ファイルを選択",
        message: template,
        buttons:
          success:
            label: 'アップロード'
            className: 'btn-primary'
            callback: =>
              $form = $('#rab_upload_file_form')
              return if !$form

              $iframe = $('iframe[name="ajaxPostFile"]')
              $iframe.off().on 'load', ->
                clearTimeout(rab_upload_timeout)

                data = $iframe.contents().find('body').html()
                if data
                  data = JSON.parse(data)
                if data.status == 200
                  $('#rab-loading-image').html("")
                  $('#rab-return-error-message').html("")
                  $('#rab-return-success-message').html("#{data.message}<br>#{data.path}")
                else
                  $('#rab-loading-image').html("")
                  $('#rab-return-success-message').html("")
                  $('#rab-return-error-message').html(data.message)
                return
              # loading 表示
              $('#rab-loading-image').html '<div class="loading"></div>'
              # timeout設定
              rab_upload_timeout = setTimeout((->
                if $('#rab-loading-image').html().match(/loading/)
                   $('#rab-loading-image').html("")
                   $('#rab-return-error-message').html '[!]タイムアウトしました。時間をおいてもう一度実行してください。'
              ), 60 * 1000)
              $form.submit()
              return false
          danger:
            label: 'キャンセル'
            className: 'btn-default'


  # ファイル一覧
  $(document).on "click", ".rab_uploaded_list", (event) ->
    event.preventDefault() if event

    if bootbox
      url = $(@).data("url")
      target = $(@).data("target")

      dfd = Rab.commonAjaxRequest(url, "GET", {init: true, target: target})
      dfd.done (data) =>
        bootboxModal = bootbox.dialog
          title: ""
          message: data.html
          buttons:
            success:
              label: "閉じる"
              className: "btn btn-register btn-default"

  # 挿入
  $(document).on 'click', '.upload-file-tag-injection', (evnet) ->
    event.preventDefault() if event
    anchor_tag = $(@).closest("li").find(".upload-file-confirm-link")[0]
    file_name = $(@).closest("li").find(".file-name")[0].innerText
    if CKEDITOR
      cke = CKEDITOR.instances[$(@).data("target")]
      html = "<a href='#{$(anchor_tag).attr("href")}'>#{file_name}</a>"
      cke.insertHtml(html)
