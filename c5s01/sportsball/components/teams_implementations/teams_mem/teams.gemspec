
$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "teams"
  s.version     = "0.0.1"
  s.authors     = ["Your name"]
  s.email       = ["Your email"]
  s.summary     = "Summary of Teams."
  s.description = "Description of Teams."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activemodel", "4.1.9"

  s.add_development_dependency "rspec"
end


