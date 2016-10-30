#!/bin/bash --login

ensure() {
    "$@" || exit 1
}

cd r4ia_examples/ticketee;

git checkout . && git clean -fd

rvm use 2.2.1@r4ia --create

gem install bundler

bundle

##########
### CREATE PERSISTENCE COMPONENT AND MOVE CODE
##########

rails plugin new components/persistence \
    --full \
    --skip-bundle --skip-git \
    --skip-test-unit \
    --skip-action-view --skip-sprockets --skip-javascript \
    --dummy-path=spec/dummy

mv app/models/* components/persistence/app/models
mkdir -p components/persistence/spec/models
mv spec/models/* components/persistence/spec/models

#pushd components/persistence && ensure eval rspec && popd

cp spec/spec_helper.rb components/persistence/spec/spec_helper.rb
cp spec/rails_helper.rb components/persistence/spec/rails_helper.rb

#pushd components/persistence && ensure eval rspec && popd

echo 'ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../dummy/config/environment", __FILE__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.include Warden::Test::Helpers, type: :feature
  config.after(type: :feature) { Warden.test_reset! }
  config.include Devise::TestHelpers, type: :controller
end
' > components/persistence/spec/rails_helper.rb

#pushd components/persistence && ensure eval rspec && popd

mkdir -p components/persistence/db/migrate
mv db/migrate/* components/persistence/db/migrate

#pushd components/persistence && \
#  rake db:migrate RAILS_ENV=test && ensure eval rspec && \
#  popd

mkdir -p components/persistence/app/uploaders
mv app/uploaders/* components/persistence/app/uploaders

#pushd components/persistence && \
#  rake db:migrate RAILS_ENV=test && ensure eval rspec && \
#  popd

echo '
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gems version:
require "persistence/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "persistence"
  s.version     = Persistence::VERSION
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Persistence."
  s.description = "TODO: Description of Persistence."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*",
      "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.2.1"
  s.add_dependency "devise", "3.4.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "3.2.1"
end
' > components/persistence/persistence.gemspec

#pushd components/persistence && \
#  rake db:migrate RAILS_ENV=test && ensure eval rspec && \
#  popd

echo '
require "devise"

module Persistence
  require "persistence/engine"
end
' > components/persistence/lib/persistence.rb

#pushd components/persistence && \
#  rake db:migrate RAILS_ENV=test && ensure eval rspec && \
#  popd

echo '
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gems version:
require "persistence/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "persistence"
  s.version     = Persistence::VERSION
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Persistence."
  s.description = "TODO: Description of Persistence."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*",
      "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.2.1"
  s.add_dependency "devise", "3.4.1"
  s.add_dependency "carrierwave", "0.10.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "3.2.1"
end
' > components/persistence/persistence.gemspec

echo '
require "devise"
require "carrierwave"

module Persistence
  require "persistence/engine"
end
' > components/persistence/lib/persistence.rb

#pushd components/persistence && \
#  rake db:migrate RAILS_ENV=test && ensure eval rspec && \
#  popd

echo '
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gems version:
require "persistence/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "persistence"
  s.version     = Persistence::VERSION
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Persistence."
  s.description = "TODO: Description of Persistence."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.2.1"
  s.add_dependency "devise", "3.4.1"
  s.add_dependency "carrierwave", "0.10.0"
  s.add_dependency "searcher"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "3.2.1"
end
' > components/persistence/persistence.gemspec

echo '
source "https://rubygems.org"

gemspec

gem "searcher", github: "radar/searcher", ref: "c2975124e11677825481ced9539f16f0cb0640de"
' > components/persistence/Gemfile

echo '
require "devise"
require "carrierwave"
require "searcher"

module Persistence
  require "persistence/engine"
end
' > components/persistence/lib/persistence.rb

#pushd components/persistence && bundle && \
#  rake db:migrate RAILS_ENV=test && ensure eval rspec && \
#  popd

mkdir -p components/persistence/config/initializers
mv config/initializers/devise.rb components/persistence/config/initializers

#pushd components/persistence && bundle && \
#  rake db:migrate RAILS_ENV=test && ensure eval rspec && \
#  popd

##########
### CLEAN UP PERSISTENCE COMPONENT
##########

rm -rf components/persistence/app/assets
rm -rf components/persistence/app/controllers
rm -rf components/persistence/app/helpers
rm -rf components/persistence/app/mailers
rm -rf components/persistence/app/models/concerns
rm -rf components/persistence/app/models/.keep
rm -rf components/persistence/app/views
rm -rf components/persistence/lib/tasks

##########
### PREP PERSISTENCE COMPONENT FOR EXTERNAL USE
##########

echo '
module Persistence
  class Engine < ::Rails::Engine
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s+File::SEPARATOR
        app.config.paths["db/migrate"].concat config.paths["db/migrate"].expanded
      end
    end
  end
end
' > components/persistence/lib/persistence/engine.rb

echo '
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
' > components/persistence/persistence.gemspec

##########
### USE PERSISTENCE IN MAIN APP
##########

echo '
source "https://rubygems.org"
ruby "2.2.1"

path "components" do
  gem "persistence"
end

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.2.1"

gem "sqlite3", group: [:development, :test]
gem "pg",      group:  :production

# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.1.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use Unicorn as the app server
# gem "unicorn"

# Use Capistrano for deployment
# gem "capistrano-rails", group: :development

gem "bootstrap-sass", "~> 3.3"
gem "font-awesome-rails", "~> 4.3"
gem "simple_form", "~> 3.1.0"
gem "devise", "~> 3.4.1"
gem "pundit", "~> 0.3.0"
gem "searcher", github: "radar/searcher"
gem "active_model_serializers", "~> 0.9.3"

gem "carrierwave", "~> 0.10.0"
gem "fog", "~> 1.29.0"
gem "rails_12factor", group: :production
gem "puma", group: :production

gem "sinatra"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug"

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 2.0"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"

  gem "rspec-rails", "~> 3.2.1"
end

group :test do
  gem "capybara", "~> 2.4"
  gem "factory_girl_rails", "~> 4.5"
  gem "selenium-webdriver", "~> 2.45"
  gem "database_cleaner", "~> 1.4"
  gem "email_spec", "~> 1.6.0"
end
' > Gemfile

#pushd components/persistence && bundle && \
#  rake db:migrate RAILS_ENV=test && ensure eval rspec && \
#  popd

##########
### ADD TEST RUNNERS
##########

echo '#!/bin/bash

exit_code=0

echo "*** Running persistence engine specs"
bundle install | grep Installing
bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
bundle exec rspec spec
exit_code+=$?

exit $exit_code
' > components/persistence/test.sh

echo '#!/bin/bash

exit_code=0

echo "*** Running container app specs"
bundle install | grep Installing
bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
bundle exec rspec spec
exit_code+=$?

exit $exit_code
' > test.sh

echo '#!/bin/bash

result=0

for test_script in $(find . -name test.sh); do
  pushd `dirname $test_script` > /dev/null
  ./test.sh
  ((result+=$?))
  popd > /dev/null
done

if [ $result -eq 0 ]; then
	echo "SUCCESS"
else
	echo "FAILURE"
fi

exit $result
' > build.sh

chmod +x components/persistence/test.sh
chmod +x test.sh
chmod +x build.sh

./build.sh
