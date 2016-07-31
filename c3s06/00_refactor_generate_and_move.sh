#!/bin/sh

#rm -rf sportsball/components/teams && git checkout sportsball && ./00_refactor_generate_and_move.sh && cd sportsball/components/teams/ && ./test.sh


cd sportsball

rvm use 2.2.2@sportsball

bundle

rails plugin new components/teams \
    --full --mountable --skip-bundle --skip-git \
    --skip-test-unit --skip-action-view --skip-sprockets \
    --skip-javascript --skip-spring --dummy-path=spec/dummy

mkdir -p components/teams/app/models/teams/
mkdir -p components/teams/spec/models/teams/
mkdir -p components/teams/spec/views/teams
mkdir -p components/teams/spec/support

mv components/app_component/app/models/app_component/team.rb \
   components/teams/app/models/teams/

mv components/app_component/spec/models/app_component/team_spec.rb\
   components/teams/spec/models/teams/

grep -rl "module AppComponent" components/teams/ | \
   xargs sed -i '' 's/module AppComponent/module Teams/g'

echo '
#!/bin/bash

exit_code=0

echo "*** Running teams engine specs"
bundle install | grep Installing
bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
bundle exec rspec spec
exit_code+=$?

exit $exit_code

' > components/teams/test.sh

chmod +x components/teams/test.sh

echo '
$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "teams"
  s.version     = "0.0.1"
  s.authors     = ["Stephan"]
  s.email       = ["Your email"]
  s.summary     = "Summary of Teams."
  s.description = "Description of Teams."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activerecord", "4.1.9"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
end

' > components/teams/teams.gemspec

echo '
source "https://rubygems.org"

gemspec

' > components/teams/Gemfile

echo '
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"

Dir[Teams::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.warnings = false
  config.profile_examples = nil
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include Teams::ObjectCreationMethods
end

' > components/teams/spec/spec_helper.rb


echo '
require File.expand_path("../boot", __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
# require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "teams"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = "Central Time (US & Canada)"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join("my", "locales", "*.{rb,yml}").to_s]
    # config.i18n.default_locale = :de
  end
end

' > components/teams/spec/dummy/config/application.rb

echo '
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application"s code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don"t have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end

' > components/teams/spec/dummy/config/environments/development.rb

echo '
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application"s
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don"t rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end

' > components/teams/spec/dummy/config/environments/test.rb





echo '
module Teams::ObjectCreationMethods
  def new_team(overrides = {})
    defaults = {
        name: "Some name #{counter}"
    }
    Teams::Team.new { |team| apply(team, defaults, overrides) }
  end

  def create_team(overrides = {})
    new_team(overrides).tap(&:save!)
  end

  private

  def counter
    @counter ||= 0
    @counter += 1
  end

  def apply(object, defaults, overrides)
    options = defaults.merge(overrides)
    options.each do |method, value_or_proc|
      object.__send__(
          "#{method}=",
          value_or_proc.is_a?(Proc) ? value_or_proc.call : value_or_proc)
    end
  end
end

' > components/teams/spec/support/object_creation_methods.rb

echo '
require_relative "../../spec/support/object_creation_methods.rb"

' > components/teams/lib/teams/test_helpers.rb


echo '
module AppComponent::ObjectCreationMethods
  def new_game(overrides = {})
    defaults = {
        first_team: -> { new_team },
        second_team: -> { new_team },
        winning_team: 2,
        first_team_score: 2,
        second_team_score: 3,
        location: "Somewhere",
        date: Date.today
    }

    AppComponent::Game.new { |game| apply(game, defaults, overrides) }
  end

  def create_game(overrides = {})
    new_game(overrides).tap(&:save!)
  end

  private

  def counter
    @counter ||= 0
    @counter += 1
  end

  def apply(object, defaults, overrides)
    options = defaults.merge(overrides)
    options.each do |method, value_or_proc|
      object.__send__(
          "#{method}=",
          value_or_proc.is_a?(Proc) ? value_or_proc.call : value_or_proc)
    end
  end
end

' > components/app_component/spec/support/object_creation_methods.rb


grep -rl "AppComponent::Team" . | \
   xargs sed -i '' 's/AppComponent::Team/Teams::Team/g'




mkdir -p components/teams/db/migrate

mv components/app_component/db/migrate/20150110181102_create_app_component_teams.rb components/teams/db/migrate/

echo '
class MoveTeamFromAppComponentToTeams < ActiveRecord::Migration
  def change
    rename_table :app_component_teams, :teams_teams
  end
end

' > components/teams/db/migrate/20150825215500_move_team_from_app_component_to_teams.rb

echo '
module Teams
  class Engine < ::Rails::Engine
    isolate_namespace Teams

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s+File::SEPARATOR
        app.config.paths["db/migrate"].concat config.paths["db/migrate"].expanded
      end
    end

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :slim
      g.test_framework  :rspec
    end
  end
end

' > components/teams/lib/teams/engine.rb


################################################################################
###     AppComponent FIX
################################################################################

echo '
Gem::Specification.new do |s|
  s.name        = "app_component"
  s.version     = "0.0.1"
  s.authors     = ["The CBRA Book"]
  s.summary     = "CBRA component"

  s.test_files = Dir["spec/**/*"]
  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.1.9"
  s.add_dependency "slim-rails", "3.0.1"
  s.add_dependency "jquery-rails", "3.1.2"

  s.add_dependency "predictor"
  s.add_dependency "teams"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
end

' > components/app_component/app_component.gemspec

echo '
source "https://rubygems.org"

gemspec

gem "trueskill", git: "https://github.com/benjaminleesmith/trueskill", ref: "e404f45af5b3fb86982881ce064a9c764cc6a901"

path "../" do
  gem "predictor"
  gem "teams"
end

' > components/app_component/Gemfile

echo '
require "slim-rails"
require "jquery-rails"

require "predictor"
require "teams"

module AppComponent
  require "app_component/engine"
end

' > components/app_component/lib/app_component.rb

echo '
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"

require "teams/test_helpers"

Dir[AppComponent::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.warnings = false
  config.profile_examples = nil
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include AppComponent::ObjectCreationMethods
  config.include Teams::ObjectCreationMethods
end

' >  components/app_component/spec/spec_helper.rb

################################################################################
###     GamesAdmin FIX
################################################################################

echo '
Gem::Specification.new do |s|
  s.name        = "games_admin"
  s.version     = "0.0.1"
  s.authors     = ["The CBRA Book"]
  s.summary     = "CBRA component"

  s.test_files = Dir["spec/**/*"]
  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.1.9"
  s.add_dependency "slim-rails", "3.0.1"
  s.add_dependency "jquery-rails", "3.1.2"

  s.add_dependency "app_component"
  s.add_dependency "teams"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
end

' > components/games_admin/games_admin.gemspec

echo '
source "https://rubygems.org"

gemspec

gem "trueskill", git: "https://github.com/benjaminleesmith/trueskill", ref: "e404f45af5b3fb86982881ce064a9c764cc6a901"

path "../" do
  gem "app_component"
  gem "teams"
end

' > components/games_admin/Gemfile

echo '
require "slim-rails"
require "jquery-rails"

require "app_component"
require "teams"

module GamesAdmin
  require "games_admin/engine"

  def self.nav_entry
    {name: "Games", link: -> {::GamesAdmin::Engine.routes.url_helpers.games_path}}
  end
end

' > components/games_admin/lib/games_admin.rb

echo '
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"

require "app_component/test_helpers"
require "teams/test_helpers"

Dir[GamesAdmin::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.warnings = false
  config.profile_examples = nil
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include AppComponent::ObjectCreationMethods
  config.include Teams::ObjectCreationMethods
end

' > components/games_admin/spec/spec_helper.rb

################################################################################
###     PredictorUI FIX
################################################################################

echo '
Gem::Specification.new do |s|
  s.name        = "predictor_ui"
  s.version     = "0.0.1"
  s.authors     = ["The CBRA Book"]
  s.summary     = "CBRA component"

  s.test_files = Dir["spec/**/*"]
  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.1.9"
  s.add_dependency "slim-rails", "3.0.1"
  s.add_dependency "jquery-rails", "3.1.2"

  s.add_dependency "predictor"
  s.add_dependency "app_component"
  s.add_dependency "teams"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
end

' > components/predictor_ui/predictor_ui.gemspec

echo '
source "https://rubygems.org"

gemspec

gem "trueskill", git: "https://github.com/benjaminleesmith/trueskill", ref: "e404f45af5b3fb86982881ce064a9c764cc6a901"

path "../" do
  gem "predictor"
  gem "app_component"
  gem "teams"
end

' > components/predictor_ui/Gemfile

echo '
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"

require "app_component/test_helpers"
require "teams/test_helpers"

Dir[PredictorUi::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.warnings = false
  config.profile_examples = nil
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include AppComponent::ObjectCreationMethods
  config.include Teams::ObjectCreationMethods
end

' > components/predictor_ui/spec/spec_helper.rb

echo '
require "slim-rails"
require "jquery-rails"

require "predictor"
require "app_component"
require "teams"

module PredictorUi
  require "predictor_ui/engine"

  def self.nav_entry
    {name: "Predictions", link: -> {::PredictorUi::Engine.routes.url_helpers.new_prediction_path}}
  end
end

' > components/predictor_ui/lib/predictor_ui.rb

################################################################################
###     TeamsAdmin FIX
################################################################################

echo '
Gem::Specification.new do |s|
  s.name        = "teams_admin"
  s.version     = "0.0.1"
  s.authors     = ["The CBRA Book"]
  s.summary     = "CBRA component"

  s.test_files = Dir["spec/**/*"]
  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.1.9"
  s.add_dependency "slim-rails", "3.0.1"
  s.add_dependency "jquery-rails", "3.1.2"

  s.add_dependency "app_component"
  s.add_dependency "teams"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
end

' > components/teams_admin/teams_admin.gemspec

echo '
source "https://rubygems.org"

gemspec

gem "trueskill", git: "https://github.com/benjaminleesmith/trueskill", ref: "e404f45af5b3fb86982881ce064a9c764cc6a901"

path "../" do
  gem "app_component"
  gem "teams"
end

' > components/teams_admin/Gemfile

echo '
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"

require "teams/test_helpers"

Dir[TeamsAdmin::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.warnings = false
  config.profile_examples = nil
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include Teams::ObjectCreationMethods
end

' > components/teams_admin/spec/spec_helper.rb

echo '
require "slim-rails"
require "jquery-rails"

require "app_component"
require "teams"

module TeamsAdmin
  require "teams_admin/engine"

  def self.nav_entry
    {name: "Teams", link: -> {::TeamsAdmin::Engine.routes.url_helpers.teams_path}}
  end
end

' > components/teams_admin/lib/teams_admin.rb
