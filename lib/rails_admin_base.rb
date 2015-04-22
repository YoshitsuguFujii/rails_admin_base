require "rails_admin_base/engine"

Dir.glob("#{RailsAdminBase::Engine.root}/lib/rails_admin_base/**/*.rb").each do |file|
  require file
end

module RailsAdminBase
end
