module RailsAdminBase
  module Generators
    class FileUploaderInstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      desc "RailsAdminBase FileUploader prepare"
      source_root File.expand_path('../templates', __FILE__)

      #class_option :route_name, desc: "url alias name", type: :string, default: "/rab"

      def self.next_migration_number(dirname)
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def mount_engine
        #engine_route = "mount RailsAdminBase::Engine => '/rails_engine_base', as: '#{options.route_name}'"
        engine_route = "mount RailsAdminBase::Engine => '/rails_engine_base', as: 'rab'"
        if File.exists?("config/routes.rb") && File.open("config/routes.rb", &:read).include?(engine_route)
          say_status("skipped", "#{engine_route} already exists in config/routes.rb")
        else
          route engine_route
        end
      end

      def create_ckeditor_migration
        copy_migration "create_upload_file"
      end

      def create_models
        destination = 'app/models/rails_admin_base/upload_file.rb'
        if File.exists?(destination)
          say_status("skipped", "#{destination} already exists")
        else
          template "models/upload_file.rb", destination
        end
      end

      protected
        def copy_migration(filename)
          if self.class.migration_exists?("db/migrate", "#{filename}")
            say_status("skipped", "Migration #{filename}.rb already exists")
          else
            migration_template "migrations/#{filename}.rb", "db/migrate/#{filename}.rb"
          end
        end
    end
  end
end
