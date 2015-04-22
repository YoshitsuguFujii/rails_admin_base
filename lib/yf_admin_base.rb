require "yf_admin_base/engine"

Dir.glob("#{YfAdminBase::Engine.root}/lib/yf_admin_base/**/*.rb").each do |file|
  require file
end

module YfAdminBase
end
