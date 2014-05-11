require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class WeightBasedOrder < ShippingCalculator
      has_many :rates, :class_name => 'Spree::WeightBasedCalculatorRate',
               :foreign_key => :calculator_id,
               :dependent => :destroy

      accepts_nested_attributes_for :rates,
                                    :allow_destroy => true

      # If weight is not defined for an item, use this instead
      preference :default_item_weight, :decimal, :default => 0

      attr_accessible :rates_attributes

      validate :validate_at_least_one_rate, :validate_rates_uniqueness

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

      def validate_at_least_one_rate
        errors.add(:rates, "must have at least one") unless rates.length > 0
      end

      def validate_rates_uniqueness
        new_or_existing_rates = rates.reject { |r| r.marked_for_destruction? }
        errors.add(:rates, "must be unique")  if new_or_existing_rates.map(&:from_value).uniq.length < new_or_existing_rates.length
      end
    end
  end
end