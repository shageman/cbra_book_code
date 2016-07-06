
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gems version:
require "games/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "games"
  s.version     = Games::VERSION
  s.authors     = ["Your name"]
  s.email       = ["Your email"]
  s.summary     = "Summary of Games."
  s.description = "Description of Games."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activerecord", "4.1.9"
  s.add_dependency "teams_store"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
end


