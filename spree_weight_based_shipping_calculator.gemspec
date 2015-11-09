# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_weight_based_shipping_calculator'
  s.version     = '0.2.0'
  s.summary     = 'Weight based shipping calculator'
  s.description = 'Calculate shipping cost based on total item weight in an order.'
  s.required_ruby_version = '>= 2.1.1'

  s.author    = 'Alan Lo'
  s.email     = 'alanlo@godaddy.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.2.0'

  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
