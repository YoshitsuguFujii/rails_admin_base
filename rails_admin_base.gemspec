$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_base"
  s.version     = RailsAdminBase::VERSION
  s.authors     = ["y.fujii"]
  s.email       = ["ishikurasakura@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RailsAdminBase."
  s.description = "TODO: Description of RailsAdminBase."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"

  s.add_development_dependency "sqlite3"
end
