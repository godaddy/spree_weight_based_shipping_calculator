module Spree
  class WeightBasedCalculatorRate < ActiveRecord::Base
    belongs_to :calculator

    scope :for_calculator, -> (calculator_id) { where(:calculator_id => calculator_id) }
    scope :for_value, -> (value) { where("from_value <= ?", value) }

    validates :calculator_id, :from_value, :rate, :presence => true
    validates :from_value, :rate, :numericality => true, :allow_blank => false
    validates_uniqueness_of :from_value, :scope => :calculator_id

    #def validate_from_value_smaller_than_to_value
    #  # ignore following cases
    #  return if from_value.nil? || to_value.nil?
    #
    #  errors.add(:base, I18n.t('errors.from_value_greater_than_to_value')) if from_value > to_value
    #end
    #
    ## All complex calculator rate types
    #def self.all_types
    #  [WEIGHT, QNTY]
    #end

    # Find the rate for the specified value
    def self.find_rate(calculator_id, value)
      range = for_calculator(calculator_id).for_value(value).order("from_value DESC").first
      range && range.rate
    end

    ## Find the previous rate for the specified value
    #def self.find_previous_rate(calculator_id, rate_type, value)
    #  rate = for_calculator(calculator_id).for_type(rate_type).where("to_value < ?", value).order("rate DESC").first()
    #  rate.nil? ? nil : rate.rate
    #end

  end
end
