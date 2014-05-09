FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_weight_based_shipping_calculator/factories'

  factory :weight_based_shipping_calculator, :class => Spree::Calculator::Shipping::WeightBasedOrder do
    calculable { Spree::ShippingMethod.first }
  end

  factory :weight_based_calculator_rate, :class => Spree::WeightBasedCalculatorRate do
    calculator { Spree::Calculator::Shipping::WeightBasedOrder.first }
  end
end
