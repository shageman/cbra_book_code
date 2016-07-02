
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gems version:
require "persistence/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "persistence"
  s.version     = Persistence::VERSION
  s.authors     = ["Stephan Hagemann"]
  s.email       = ["stephan.hagemann@gmail.com"]
  s.summary     = "Persistence."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.2.1"
  s.add_dependency "devise", "3.4.1"
  s.add_dependency "carrierwave", "0.10.0"
  s.add_dependency "searcher"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "3.2.1"
end

