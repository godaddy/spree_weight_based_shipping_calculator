require 'spec_helper'

describe Spree::WeightBasedCalculatorRate do
  before(:all) do
    @shipping_method = FactoryBot.create(:shipping_method)
  end

  let(:calculator) { OpenStruct.new(id: 1) }

  let(:rate1) { FactoryBot.build(:weight_based_calculator_rate,
                                  calculator_id: calculator.id,
                                  from_value: 0,
                                  rate: 10) }
  let(:rate2) { FactoryBot.build(:weight_based_calculator_rate,
                                  calculator_id: calculator.id,
                                  from_value: 8,
                                  rate: 15) }

  it { should belong_to(:calculator) }

  specify { expect(rate1).to be_valid }

  it { should validate_presence_of(:from_value) }
  it { should validate_numericality_of(:from_value).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(99999.999) }

  it { should validate_presence_of(:rate) }
  it { should validate_numericality_of(:rate).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(999999.99) }

  context "::find_rate" do
    it "should find nothing when there are no rates" do
      expect(Spree::WeightBasedCalculatorRate.count).to eq(0)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 10)).to be_nil
    end

    it "should find a valid rate (from a single entry)" do
      rate1.save!

      expect(Spree::WeightBasedCalculatorRate.count).to eq(1)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 0)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 0.1)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 1)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 50)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 99)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 99.9)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 100)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 200.1)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, -5)).to be_nil
    end

    it "should find a valid rate (from two entries)" do
      rate1.save!
      rate2.save!

      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 0)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 0.1)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 1)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 3)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 7.9)).to eq(10)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 8)).to eq(15)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 8.1)).to eq(15)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 100.1)).to eq(15)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 101)).to eq(15)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 499)).to eq(15)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 499.9)).to eq(15)
      expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 500)).to eq(15)
    end
  end
end
