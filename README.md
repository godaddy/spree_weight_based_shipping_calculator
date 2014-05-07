SpreeWeightBasedShippingCalculator
==================================

Inspired by https://github.com/jurgis/spree-additional-calculators

Installation
------------

Add spree_weight_based_shipping_calculator to your Gemfile:

```ruby
gem 'spree_weight_based_shipping_calculator'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_weight_based_shipping_calculator:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_weight_based_shipping_calculator/factories'
```

Copyright (c) 2014 [name of extension creator], released under the New BSD License
