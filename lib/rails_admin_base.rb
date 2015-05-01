# Gemをホスト側アプリに読み込ませる
Gem.loaded_specs['rails_admin_base'].dependencies.each do |d|
  begin
    require d.name
  rescue LoadError
    raise
  end
end

require "rails_admin_base/engine"

Dir.glob("#{RailsAdminBase::Engine.root}/lib/rails_admin_base/**/*.rb").each do |file|
  require file
end

ActiveSupport.on_load(:action_controller) do
  include RailsAdminBase::Controllers::ControllerFilter
end

module RailsAdminBase
end
