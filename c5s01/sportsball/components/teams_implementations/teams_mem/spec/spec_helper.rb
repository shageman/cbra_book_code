
ENV["RAILS_ENV"] ||= "test"

require "active_model"

require File.expand_path("../../lib/teams/db", __FILE__)
require File.expand_path("../../lib/teams/team", __FILE__)
require File.expand_path("../../lib/teams/team_repository.rb", __FILE__)

require "rspec"

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f}

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

  config.before(:each) do
    Teams::Db.reset
  end

  config.include Teams::ObjectCreationMethods
end


