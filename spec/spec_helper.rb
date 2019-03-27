if ENV["COVERAGE"]
  require_relative 'rcov_exclude_list.rb'
  exlist = Dir.glob(@exclude_list)
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start do
    exlist.each do |p|
      add_filter p
    end
  end
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'ffaker'

# Requires factories defined in spree_core
require 'spree/testing_support/factories'
require 'rspec/active_model/mocks'
require 'shoulda-matchers'

# Requires factories defined in lib/spree_weight_based_shipping_calculator/factories.rb
require 'spree_weight_based_shipping_calculator/factories'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.mock_with :rspec
  config.use_transactional_fixtures = true

  config.fail_fast = ENV['FAIL_FAST'] || false
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

if ENV["COVERAGE"]
  # Load all files except the ones in exclude list
  require_all(Dir.glob('**/*.rb') - exlist)
end
