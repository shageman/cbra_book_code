#!/bin/sh

#rm -rf sportsball/components/games && git checkout sportsball && ./01_refactor_generate_and_move.sh && cd sportsball/components/games/ && ./test.sh


cd sportsball

rvm use 2.2.2@sportsball

bundle

rails plugin new components/games --full --mountable --skip-bundle --skip-git --skip-test-unit --skip-action-view --skip-sprockets --skip-javascript --dummy-path=spec/dummy

mkdir -p components/games/app/models/games/
mkdir -p components/games/spec/models/games/
mkdir -p components/games/spec/views/games
mkdir -p components/games/spec/support

mv components/app_component/app/models/app_component/game.rb \
   components/games/app/models/games/

mv components/app_component/spec/models/app_component/game_spec.rb\
   components/games/spec/models/games/

grep -rl "module AppComponent" components/games/ | \
   xargs sed -i '' 's/module AppComponent/module Games/g'

echo '
#!/bin/bash

exit_code=0

echo "*** Running games engine specs"
bundle install | grep Installing
bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
bundle exec rspec spec
exit_code+=$?

exit $exit_code

' > components/games/test.sh

chmod +x components/games/test.sh

echo '
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
  s.add_dependency "teams"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "database_cleaner"
end

' > components/games/games.gemspec

echo '
source "https://rubygems.org"

gemspec

path "../" do
  gem "teams"
end

' > components/games/Gemfile

echo '
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"

Dir[Games::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}

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

  config.include Games::ObjectCreationMethods
end

' > components/games/spec/spec_helper.rb

grep -rl "AppComponent::Game" . | \
   xargs sed -i '' 's/AppComponent::Game/Games::Game/g'

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
require "games"

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

' > components/games/spec/dummy/config/application.rb

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

' > components/games/spec/dummy/config/environments/development.rb

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

' > components/games/spec/dummy/config/environments/test.rb

echo '
module Games::ObjectCreationMethods
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

    Games::Game.new { |game| apply(game, defaults, overrides) }
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

' > components/games/spec/support/object_creation_methods.rb

rm components/app_component/spec/support/object_creation_methods.rb
rm components/app_component/lib/app_component/test_helpers.rb

mkdir -p components/games/db/migrate

mv components/app_component/db/migrate/20150110184219_create_app_component_games.rb components/games/db/migrate/

echo '
class MoveGameFromAppComponentToGames < ActiveRecord::Migration
  def change
    rename_table :app_component_games, :games_games
  end
end

' > components/games/db/migrate/20150820071900_move_game_from_app_component_to_games.rb

echo '
module Games
  class Engine < ::Rails::Engine
    isolate_namespace Games

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

' > components/games/lib/games/engine.rb

echo '

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"

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
end

' > components/app_component/spec/spec_helper.rb

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
  s.add_dependency "games"

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
  gem "games"
end

' > components/games_admin/Gemfile

echo '

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"

require "teams/test_helpers"
require "games/test_helpers"

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

  config.include Teams::ObjectCreationMethods
  config.include Games::ObjectCreationMethods
end

' > components/games_admin/spec/spec_helper.rb

echo '

require "slim-rails"
require "jquery-rails"

require "app_component"
require "teams"
require "games"

module GamesAdmin
  require "games_admin/engine"

  def self.nav_entry
    {name: "Games", link: -> {::GamesAdmin::Engine.routes.url_helpers.games_path}}
  end
end

' > components/games_admin/lib/games_admin.rb

echo '
require_relative "../../spec/support/object_creation_methods.rb"

' > components/games/lib/games/test_helpers.rb


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
  s.add_dependency "games"

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
  gem "games"
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

require "teams/test_helpers"
require "games/test_helpers"

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

  config.include Teams::ObjectCreationMethods
  config.include Games::ObjectCreationMethods
end

' > components/predictor_ui/spec/spec_helper.rb

echo '

require "slim-rails"
require "jquery-rails"

require "predictor"
require "app_component"
require "teams"
require "games"

module PredictorUi
  require "predictor_ui/engine"

  def self.nav_entry
    {name: "Predictions", link: -> {::PredictorUi::Engine.routes.url_helpers.new_prediction_path}}
  end
end

' > components/predictor_ui/lib/predictor_ui.rb
