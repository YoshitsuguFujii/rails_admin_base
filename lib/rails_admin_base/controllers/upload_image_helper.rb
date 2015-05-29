##
# == 概要
#
# ファイルアップロード処理をまとめてコントローラ ヘルパークラス
#
module UploadImageHelper
  # 保留
#
#  #
#  # ApplicationControllerにincludeするモジュール
#  #
#  module UploadImageController
#    def file_upload(options = {})
#      controller_name = self.name.sub("Controller","")
#      configuration = { controller: controller_name}
#      configuration.update(options) if options.is_a?(Hash)
#
#      class_eval do
#        include UploadImageHelper::UploadImageController::InstanceMethods
#
#        helper do
#          include UploadImageHelper::UploadImageController::HelperMethods
#        end
#      end
#    end
#  end
#
#  #
#  # 各コントローラにincludeされるモジュール
#  #
#  module InstanceMethods
#    class UploadFileIsEmpty < StandardError; end;
#
#    def upload_image
#      if params[:file].blank?
#        raise UploadFileIsEmpty
#      end
#
#      # file upload
#      if Rails.env.development?
#        file_path = "http://cdn.qiita.com/assets/siteid-reverse-fc570663acbf0b8e0820ceeb2abb21e5.png"
#        res = {
#          "thumbnail_uri" => file_path,
#        }
#      else
#        share_with = if %w(teachers).include?(controller_name)
#                       "all"
#                     else
#                       "school:#{current_user.school_id}"
#                     end
#
#        response = ClassiPlatformClient.post_backdoor_cbank_userconfig_upload(
#          user_id: current_user.id,
#          payload: {
#            file: params[:file],
#            share_with: share_with,
#            teacher_permission: 4,
#            student_permission: 0
#          }
#        )
#        res = JSON.parse(response.body)
#      end
#
#      res.merge!(thumbnail_uri: "#{Settings.platform.scheme}://#{Settings.platform.host}/api/cbank/#{res["entry_cd"]}/thumbnail")
#
#      render html: {status: response.code, message: ClassiPlatformClient.convert_message(res["message"]), res: res}.to_json
#    rescue UploadFileIsEmpty => ex
#      render html: {status: 400, message: "ファイルが選択されていません"}.to_json
#    rescue Errno::ECONNREFUSED => ex
#      render html: {status: 403, message: "接続が拒否されました"}
#    rescue ActiveRecord::RecordNotFound => ex
#      render html: {status: 404, message: "対象ユーザが見つかりませんでした"}.to_json
#    rescue Errno::ENOENT => ex
#      render html: {status: 404, message: "ファイルが見つかりませんでした"}.to_json
#    rescue Net::ReadTimeout => ex
#      render html: {status: 408, message: "接続がタイムアウトしました"}.to_json
#    rescue => ex
#      render html: {status: 500, message: "画像登録に失敗しました"}.to_json
#    end
#  end
#
#  #
#  # 各コントローラにヘルパーとしてincludeされるモジュール
#  #
#  module HelperMethods
#
#    def cbank_file_field(f, attribute)
#      model = f.object.class.name.singularize.underscore
#
#      html = content_tag(:div, class: "cbanks_file_upload") do
#        html = content_tag(:div, id: 'photo_image', class: "mb5", style: "position: relative") do
#          if f.object[attribute].present?
#            image = image_tag(f.object[attribute], class: "cbanks_file_upload_image", width: "120px")
#            unless default_image?(f, f.object[attribute])
#              image << link_to("[削除]", "#", class: "cbanks_file_delete", style: "position: absolute; bottom: 0px;")
#            end
#            image.html_safe
#          else
#            ""
#          end
#        end
#
#        html << hidden_field_tag("#{model}[#{attribute}]", f.object[attribute], id: "cbanks_photo_url")
#        html << link_to('ファイル登録', "#", class: 'btn btn-default upload-btn cbanks_image_upload_ajax', "data-id" => f.object.id)
#        html << '<iframe name="ajaxPostImage" style="display:none; width:0; height:0"></iframe>'.html_safe
#      end
#      html.html_safe
#    end
#
#    def default_image?(f, path)
#      Settings.platform.default_user_image.send(f.object.class.name.downcase).to_hash.values.include?(path)
#    end
#
#    def cbank_file_upload_js
#      template = <<-"HTML_EOS".strip_heredoc
#        #{form_tag("cbank_upload_image", id: "cbank-upload-form", multipart: true, target: "ajaxPostImage")}
#          <div class="row">
#            <label class="col-md-4 control-label">ファイルを選択</label>
#            <div class="col-md-4">
#              <input id="file" name="file" style="width: 300px;" type="file">
#            </div>
#          </div>
#        </form>
#      HTML_EOS
#
#      content_for(:js) do
#        js = <<-"JS_EOS".strip_heredoc
#          $(document).on('click', ".cbanks_file_delete", function(event){
#            event.preventDefault();
#
#            $('#photo_image').html("");
#            $('#cbanks_photo_url').val("")
#          });
#
#          $(document).on('click', ".cbanks_image_upload_ajax", function(event){
#            event.preventDefault();
#            var template = '#{template.gsub("\n", "")}';
#
#            bootbox.dialog({
#              title: "画像を選択",
#              message: template,
#              buttons: {
#                success: {
#                  label: "アップロード",
#                  className: "btn-primary",
#                  callback: (function(_this) {
#                    return function(e) {
#                      var $form = $("#cbank-upload-form");
#                      if (!$form) return;
#
#                      var $iframe = $('iframe[name="ajaxPostImage"]');
#                      $iframe.off().on('load', function() {
#                        clearTimeout(cbanks_upload_timeout);
#
#                        var data = $iframe.contents().find("body").html();
#                        if(data){
#                          data = JSON.parse(data)
#                        }
#
#                        if (data.status == 200) {
#                          // hiddenに値を設定。画像を表示
#                          var image = "<img src='" + data.res.thumbnail_uri + "' class='cbanks_file_upload_image' width='120px'>";
#                          image += '<a class="cbanks_file_delete" href="#" style="position: absolute; bottom: 0px;">[削除]</a>';
#                          $('#photo_image').html(image);
#                          $('#cbanks_photo_url').val(data.res.thumbnail_uri)
#                        }else{
#                          // hiddenの値をクリア。エラーメッセージを表示、
#                          $('#photo_image').html("<p class='error-message mb5'>[!]" + data.message + "</p>");
#                          $('#cbanks_photo_url').val("")
#                        }
#                      });
#
#                      // loading 表示
#                      $('#photo_image').html('<div class="loading"></div>');
#
#                      // timeout設定
#                      cbanks_upload_timeout = setTimeout(function(){
#                        if($('#photo_image').html().match(/loading/)){
#                          $('#photo_image').html("<p class='error-message mb5'>[!]タイムアウトしました。時間をおいてもう一度実行してください。</p>");
#                        }
#                      }, 60 * 1000);
#
#                      $form.submit();
#                    };
#                  })(this)
#                },
#                danger: {
#                  label: "キャンセル",
#                  className: "btn-default"
#                }
#              }
#            });
#         });
#       JS_EOS
#
#       javascript_tag(js)
#     end
#    end
#  end
end
