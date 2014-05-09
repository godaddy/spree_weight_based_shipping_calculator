require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class WeightBasedOrder < ShippingCalculator
      has_many :rates, :class_name => 'Spree::WeightBasedCalculatorRate',
               :foreign_key => :calculator_id,
               :dependent => :destroy

      accepts_nested_attributes_for :rates,
                                    :allow_destroy => true,
                                    :reject_if => proc { |attr| attr[:from_value].blank? && attr[:rate].blank? }

      #before_save :set_is_weight_based_calculator

      # If weight is not defined for an item, use this instead
      preference :default_item_weight, :decimal, :default => 0

      def self.description
        Spree.t(:weight_based_shipping_rate_per_order)
      end

      def compute_package(package)
        content_items = package.contents

        total_weight = total_weight(content_items)
        cost = get_rate(total_weight)

        cost.to_f
      end

      def available?(package)
        package.contents.any? && Spree::WeightBasedCalculatorRate.for_calculator(self.id).count > 0
      end

      ## TODO: Check if this is needed.
      def self.register
        super
      end

      ## Return calculator name
      #def name
      #  calculable.respond_to?(:name) ? calculable.name : calculable.to_s
      #end

      def sorted_rates
        spree_weight_based_calculator_rates.order("from_value ASC")
      end

      private

      def total_weight(contents)
        weight = 0
        contents.each do |item|
          weight += item.quantity * (item.variant.weight || preferred_default_item_weight)
        end

        weight
      end

      # Get the rate from the database or nil if could not find the rate
      def get_rate(value)
        Spree::WeightBasedCalculatorRate.find_rate(self.id, value)
      end

      ## Get the previous rate if rate for the specified value does not exist, return nil if no previous rate can be find
      #def get_previous_rate(value, rate_type)
      #  AdditionalCalculatorRate.find_previous_rate(self.id, rate_type, value)
      #end

      ## Before saving the record set that this is the weight based calculator
      #def set_is_weight_based_calculator
      #  self.is_weight_based_calculator = true
      #end
    end
  end
end