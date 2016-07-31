#!/bin/sh

cd sportsball
rvm use 2.2.2@sportsball

rails plugin new components/games_admin --full --mountable --skip-bundle \
    --skip-git --skip-test-unit --dummy-path=spec/dummy

mkdir -p components/games_admin/app/views/games_admin
mkdir -p components/games_admin/spec/controllers/games_admin
mkdir -p components/games_admin/spec/views/games_admin
mkdir -p components/games_admin/spec/routing/games_admin
mkdir -p components/games_admin/spec/features
mkdir -p components/games_admin/spec/support

mv components/app_component/app/controllers/app_component/games_controller.rb \
   components/games_admin/app/controllers/games_admin/
mv components/app_component/app/views/app_component/games\
   components/games_admin/app/views/games_admin/games

mv components/app_component/spec/controllers/\
      app_component/games_controller_spec.rb\
   components/games_admin/spec/controllers/games_admin/
mv components/app_component/spec/views/app_component/games\
   components/games_admin/spec/views/games_admin
mv components/app_component/spec/routing/app_component/games_routing_spec.rb\
   components/games_admin/spec/routing/games_admin
mv components/app_component/spec/features/games_spec.rb\
   components/games_admin/spec/features

grep -rl "module AppComponent" components/games_admin/ | \
   xargs sed -i '' 's/module AppComponent/module GamesAdmin/g'
grep -rl "AppComponent::GamesController" components/games_admin/ | \
   xargs sed -i '' 's/AppComponent::GamesController/GamesAdmin::GamesController/g'
grep -rl "AppComponent::Engine" components/games_admin/ | \
   xargs sed -i '' 's/AppComponent::Engine/GamesAdmin::Engine/g'
grep -rl "app_component/" components/games_admin/ | \
   xargs sed -i '' 's;app_component/;games_admin/;g'
grep -rl "app_component\." components/games_admin/ | \
   xargs sed -i '' 's;app_component\.;games_admin\.;g'


echo '
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gems version:
require "games_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "games_admin"
  s.version     = GamesAdmin::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of GamesAdmin."
  s.description = "TODO: Description of GamesAdmin."
  s.license     = "MIT"

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
' > components/games_admin/games_admin.gemspec

echo "
source 'https://rubygems.org'

gemspec

path '..' do
  gem 'app_component'
end

" > components/games_admin/Gemfile


echo '
module GamesAdmin
  class Engine < ::Rails::Engine
    isolate_namespace GamesAdmin

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

' > components/games_admin/lib/games_admin/engine.rb




echo '
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"

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

  config.include ObjectCreationMethods
end

' > components/games_admin/spec/spec_helper.rb

echo '
#!/bin/bash

exit_code=0

echo "*** Running games admin engine specs"
bundle install | grep Installing
bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
bundle exec rspec spec
exit_code+=$?

exit $exit_code

' > components/games_admin/test.sh

chmod +x components/games_admin/test.sh

echo '
require_relative "../../spec/support/object_creation_methods.rb"

' > components/app_component/lib/app_component/test_helpers.rb

echo '
module AppComponent::ObjectCreationMethods
  def new_team(overrides = {})
    defaults = {
        name: "Some name #{counter}"
    }
    AppComponent::Team.new { |team| apply(team, defaults, overrides) }
  end

  def create_team(overrides = {})
    new_team(overrides).tap(&:save!)
  end

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

echo '
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"

require "app_component/test_helpers"

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
end

' > components/games_admin/spec/spec_helper.rb

echo '
GamesAdmin::Engine.routes.draw do
  resources :games
end

' > components/games_admin/config/routes.rb












echo '
AppComponent::Engine.routes.draw do
  resources :teams

  resource :welcome, only: [:show]
  resource :prediction, only: [:new, :create]

  root to: "welcomes#show"
end

' > components/app_component/config/routes.rb


echo '
ActionView::TestCase::TestController.instance_eval do
  helper GamesAdmin::Engine.routes.url_helpers
end
ActionView::TestCase::TestController.class_eval do
  def _routes
    GamesAdmin::Engine.routes
  end
end

' > components/games_admin/spec/support/view_spec_fixes.rb

echo '
RSpec.describe "games admin", :type => :feature do
  before :each do
    team1 = create_team name: "UofL"
    team2 = create_team name: "UK"

    create_game first_team: team1, second_team: team2, winning_team: 1
  end

  it "allows for the management of games" do
    visit "/games_admin/games"

    expect(page).to have_content "UofL"
  end
end

' > components/games_admin/spec/features/games_spec.rb

#cd components/games_admin
#
#./test.sh
#
#cd ../..



echo '
source "https://rubygems.org"
ruby "2.2.2"

path "components" do
  gem "app_component"
  gem "games_admin"
end

#Ensuring correct version of transitive dependency
gem "trueskill", git: "https://github.com/benjaminleesmith/trueskill",
  ref: "e404f45af5b3fb86982881ce064a9c764cc6a901"

gem "rails", "4.1.9"
gem "sass-rails", "~> 4.0.3"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"
gem "turbolinks"
gem "jbuilder", "~> 2.0"
gem "sdoc", "~> 0.4.0", group: :doc

group :development, :test do
  gem "sqlite3"
  gem "spring"
  gem "rspec-rails"
  gem "capybara"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end

' > Gemfile

echo '
Rails.application.routes.draw do
  mount AppComponent::Engine, at: "/app_component"
  mount GamesAdmin::Engine, at: "/games_admin"

  root to: "app_component/welcomes#show"
end

' > config/routes.rb


rm -rf components/games_admin/app/views/layouts

echo '
module GamesAdmin
  class ApplicationController < ActionController::Base
    layout "app_component/application"
  end
end

' > components/games_admin/app/controllers/games_admin/application_controller.rb



echo '
|<!DOCTYPE html>
html
  head
    meta charset="utf-8"
    meta name="viewport" content="width=device-width, initial-scale=1.0"

    title Sportsball App

    = javascript_include_tag "app_component/application"
    = stylesheet_link_tag    "app_component/application", media: "all"

    = csrf_meta_tags

  header
    .contain-to-grid.sticky
      nav.top-bar data-topbar="" role="navigation"
        ul.title-area
          li.name
            h1
              = link_to "/" do
                = image_tag "app_component/logo.png", width: "25px"
                | Predictor

          li.toggle-topbar.menu-icon
            a href="#"
              span Menu

        section.top-bar-section
          ul.left
            li =link_to "Teams", "/app_component/teams"
            li =link_to "Games", "/games_admin/games"
            li =link_to "Predictions", "/app_component/prediction/new"

  main
    .row
      .small-12.columns
        = yield

' > components/app_component/app/views/layouts/app_component/application.html.slim

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

  config.include AppComponent::ObjectCreationMethods
end

' > components/app_component/spec/spec_helper.rb
