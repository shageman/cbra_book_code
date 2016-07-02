ENV["RAILS_ENV"] ||= "test"
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

