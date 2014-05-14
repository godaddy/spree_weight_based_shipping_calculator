Spree Weight Based Shipping Calculator
======================================

Inspired by https://github.com/jurgis/spree-additional-calculators

Determine shipping cost based on total items' weight. The minimum weight is always zero and maximum weight is always
infinite. You can specify any number of weights between the minimum and maximum, and each weight, including zero weight, will have a corresponding
shipping cost. The shipping cost of an order is determined by comparing the list of shipping weight against the order's
weight - First, find the lowest shipping weight in the list that is greater than the order weight, its corresponding shipping
cost is the shipping cost of the order. For example, here is the list of weights and its shipping cost configuration:

```
Weight(lb)      Shipping Cost
   0.0              $5.0
   5.0              $10.0
   20.0             $15.0
```
and here is the shipping cost for the following orders:
```
Order weight        Shipping Cost
    3.0lb               $5.0
    5.0lb               $5.0
    5.1lb               $10.0
    9.2lb               $10.0
    29lb                $15.0
    50lb                $15.0
    90lb                $15.0
```
Note: Currently, UI for Admin is not provided in this gem.

Installation
------------

Add spree_weight_based_shipping_calculator to your Gemfile:

```ruby
gem 'spree_weight_based_shipping_calculator'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
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
