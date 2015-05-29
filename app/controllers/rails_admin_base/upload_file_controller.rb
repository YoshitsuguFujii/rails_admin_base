class RailsAdminBase::UploadFileController < RailsAdminBase::ApplicationController
  class UploadFileIsEmpty < StandardError; end;
  PER_PAGE = 6
  before_action :load_instances

  def index
    if params[:init] == "true"
      params[:init] = nil
      html =  render_to_string(action: :index, layout: nil)
      render json: { html: html }
    else
      if @upload_files.blank? && @upload_files.total_pages == 1 && @upload_files.current_page  != 1
        params[:page] = 1
        load_instances
      end
      render 'parts/index'
    end
  end

  def create
    if params[:file_name].blank?
      raise UploadFileIsEmpty
    else
      upload_file = RailsAdminBase::UploadFile.find_or_initialize_by(data_file_name: params[:file_name].original_filename)
      message = if upload_file.new_record?
                  "ファイルが登録されました"
                else
                  "ファイルが更新されました"
                end
      upload_file.data_content_type = params[:file_name].content_type
      upload_file.data_file_size = params[:file_name].size
      upload_file.data_file_name = params[:file_name].original_filename
      upload_file.store_file(params[:file_name])
      upload_file.save!
    end

    render html: {status: 200, message: message , path: upload_file.file_url}.to_json
  rescue UploadFileIsEmpty => ex
    render html: {status: 400, message: "ファイルが選択されていません"}.to_json
  rescue => ex
    render html: {status: 500, message: ex.message}.to_json
  end

  def tmp_upload
    temp_dir = ["public", "temp_file"]

    # 過去のディレクトリは削除
    dir_path = Rails.root.join( *temp_dir )
    dir_today = Date.today.strftime("%Y%m%d")
    Dir.glob(dir_path.join("*")).each do |dir|
      if dir.split("/").last != dir_today && FileTest::directory?(dir)
        FileUtils.rm_rf(dir)
      end
    end
    store_dir = dir_path.join(dir_today)
    FileUtils.mkdir_p(store_dir) unless FileTest::directory?(store_dir)

    files = []
    image_params = params[params[:paramsKey]].deep_reject{|key, value| !value.is_a?(ActionDispatch::Http::UploadedFile)}
    image_params.each do |param_key, file_param|
      file_name = file_param.original_filename
      path = store_dir.join(file_name)
      File.open(path, "wb") do |f|
        f.write(file_param.read)
      end
      files << {param_key => path.to_s.gsub(Rails.root.join("public").to_s, "")}
    end

    render json: files
  end

  def destroy
    upload_file = RailsAdminBase::UploadFile.find(params[:id])
    upload_file.destroy

    render json: {status: 200, id: upload_file.id, message: t("delete_complete")}
  rescue => ex
    render json: {status: 500, message: ex.message}
  end

  def load_instances
    @upload_files = RailsAdminBase::UploadFile.all.order(id: :desc).page(params[:page]).per(PER_PAGE)
  end
end
