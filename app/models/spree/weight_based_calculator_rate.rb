module Spree
  class WeightBasedCalculatorRate < ActiveRecord::Base
    belongs_to :calculator

    scope :for_calculator, -> (calculator_id) { where(:calculator_id => calculator_id) }
    scope :for_value, -> (value) { where("from_value <= ?", value) }

    validates :calculator_id, :from_value, :rate, :presence => true
    validates :from_value, :rate, :numericality => { greater_than_or_equal_to: 0 }, :allow_blank => false
    validates_uniqueness_of :from_value, :scope => :calculator_id

    attr_accessible :from_value, :rate

    # Find the rate for the specified value
    def self.find_rate(calculator_id, value)
      range = for_calculator(calculator_id).for_value(value).order("from_value DESC").first
      range && range.rate
    end

  end
end
