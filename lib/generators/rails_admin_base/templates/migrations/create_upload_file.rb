class CreateUploadFile < ActiveRecord::Migration
  def self.up
    create_table :upload_files do |t|
      t.string  :data_file_name, :null => false
      t.string  :data_content_type
      t.integer :data_file_size
      t.string :file_path

      t.timestamps
    end
  end

  def self.down
    drop_table :upload_files
  end
end
