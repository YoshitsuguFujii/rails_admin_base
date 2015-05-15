class RailsAdminBase::UploadFile < ActiveRecord::Base
  self.table_name = "upload_files"
  DESTINATION_DIRECTORY = Rails.root.join("public","upload_files")

  before_destroy :delete_stored_file

  def file_url
   "/#{file_path.split("/").drop_while{|path| path != "public"}.last(2).join("/")}"
  end

  def store_file(params_file)
    FileUtils.mkdir_p(DESTINATION_DIRECTORY) unless FileTest::directory?(DESTINATION_DIRECTORY)
    #time_stamp = Time.now.strftime("%Y%m%d%H%M%S") + Time.now.usec.to_s
    #path = DESTINATION_DIRECTORY.join("#{data_file_name}_#{time_stamp}")
    path = DESTINATION_DIRECTORY.join("#{data_file_name}")
    File.open(path, "wb") do |f|
      f.write(params_file.read)
    end
    self.file_path = path
  end

  private
  def delete_stored_file
    File.delete(file_path)
  end
end
