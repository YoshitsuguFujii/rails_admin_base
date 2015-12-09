module FileUploader
  extend ActiveSupport::Concern

  STORE_PUBLIC_DIR_NAME= "upload_files"

  included do
    attr_accessor :file
    attr_accessor :file_cache_name
    attr_accessor :cache_identifier

    before_validation :set_tmp_file
    after_save :set_file
    after_save :delete_file
    after_commit :delete_tmp_dir
    after_destroy :delete_dir
  end

  module ClassMethods
    def clean_cached_files!(days = 1.days.ago)
      temp_dir = Rails.root.join('tmp', STORE_PUBLIC_DIR_NAME, self.name.underscore)
      Dir.glob(temp_dir/ "*").each do |dir|
        dir_day = dir.scan(/(\d+)_\d+/).first.map(&:to_i).first rescue 0
        if dir_day <= days.strftime('%y%m%d').to_i
          logger.info("ディレクトリを削除します[RAB-1] -> #{dir}")
          FileUtils.rm_rf(dir)
        end
      end
    end
  end

  def set_tmp_file
    if file.present?
      self.data_content_type = file.content_type
      self.data_file_size = file.size
      self.data_file_name = file.original_filename
      store_temp_file
      self.cache_identifier = [file_cache_name.to_s, data_file_name].join("/")
    elsif cache_identifier.present?
      dir = temp_store_dir
      file_name = cache_identifier.split("/").last
      path = [dir, file_name].join("/")
      self.data_content_type = MIME::Types.type_for(path)[0].to_s.presence || "application/octet-stream"
      self.data_file_size = File.size(path)
      self.data_file_name = file_name
      self.file_cache_name
      self.cache_identifier = [file_cache_name.to_s, data_file_name].join("/")
      self.file_path = path
    end
  end

  def set_file
    if self.file_cache_name.present?
      store_file
    end
  end

  def changed_for_autosave?
    if file.present?
      return true
    end
    super
  end

  private

  def store_temp_file
    dir = temp_store_dir
    path = "#{dir}/#{data_file_name}"
    File.open(path, 'wb') do |f|
      logger.info("ファイルを作成します[RAB-2] -> #{path}")
      f.write(file.read)
    end
    self.file_path = path
  end

  def store_file
    src = self.file_path
    dir = store_dir
    dest = dir.join("#{data_file_name}")
    logger.info("ファイルを移動します[RAB-3] : #{src} -> #{dest}")
    FileUtils.move(src, dest)
    self.update_columns(file_path: dest.to_s)
  end

  def temp_store_dir
    self.file_cache_name = self.file_cache_name.presence || "#{Time.now.strftime('%y%m%d_%H%M')}"
    path = Rails.root.join('tmp', STORE_PUBLIC_DIR_NAME, self.class.name.underscore, self.file_cache_name)
    FileUtils.mkdir_p(path) unless FileTest.directory?(path)
    path
  end

  def store_dir
    path = Rails.root.join('public', STORE_PUBLIC_DIR_NAME, self.class.name.underscore, self.id.to_s)
    FileUtils.mkdir_p(path) unless FileTest.directory?(path)
    path
  end

  def delete_file
    if self.file_path_was.present? && self.file_path_changed? && self.data_file_name_was != self.data_file_name
      logger.info("ファイルを削除します[RAB-4] -> #{self.file_path_was}")
      FileUtils.rm_rf(self.file_path_was)
    end
  end

  def delete_tmp_dir
    logger.info("tmpディレクトリを削除します[RAB-5] -> #{temp_store_dir}")
    FileUtils.rm_rf(temp_store_dir)
  end

  def delete_dir
    logger.info("ディレクトリを削除します[RAB-6] -> #{store_dir}")
    FileUtils.rm_rf(store_dir)
  end
end
