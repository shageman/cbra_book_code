$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "app_component/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "app_component"
  s.version     = AppComponent::VERSION
  s.authors     = ["The CBRA Book"]
  s.summary     = "CBRA component"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "5.0.0.1"
  s.add_dependency "slim-rails", "3.1.0"
  s.add_dependency "trueskill"
  s.add_dependency "jquery-rails", "4.1.1"

  s.add_development_dependency "sqlite3", "1.3.10"
  s.add_development_dependency "rspec-rails", "3.1.0"
  s.add_development_dependency "shoulda-matchers", "2.7.0"
  s.add_development_dependency "database_cleaner", "1.4.0"
  s.add_development_dependency "capybara", "2.7.1"
  s.add_development_dependency "rails-controller-testing", "1.0.0"
end
