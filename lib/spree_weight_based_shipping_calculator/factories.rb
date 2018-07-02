FactoryBot.define do
  factory :weight_based_shipping_calculator, class: Spree::Calculator::Shipping::WeightBasedOrder do
    calculable { Spree::ShippingMethod.first }
  end

  factory :weight_based_calculator_rate, class: Spree::WeightBasedCalculatorRate do
    calculator { Spree::Calculator::Shipping::WeightBasedOrder.first }
  end
end
