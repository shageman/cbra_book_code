$:.push File.expand_path("../lib", __FILE__)

# Maintain your gems version:
require "games_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "games_admin"
  s.version     = GamesAdmin::VERSION
  s.authors     = ["Your name"]
  s.email       = ["Your email"]
  s.summary     = "GamesAdmin"
  s.description = "GamesAdmin"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.1.9"
  s.add_dependency "slim-rails", "3.0.1"
  s.add_dependency "jquery-rails", "3.1.2"

  s.add_dependency "app_component"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"

end

