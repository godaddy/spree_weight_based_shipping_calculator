require 'spec_helper'

describe Spree::WeightBasedCalculatorRate do
  before(:all) do
    @shipping_method = FactoryGirl.create(:shipping_method)
  end

  let(:calculator) { OpenStruct.new(id: 1) }

  let(:rate1) { FactoryGirl.build(:weight_based_calculator_rate,
                                  :calculator_id => calculator.id,
                                  :from_value => 0,
                                  :rate => 10) }
  let(:rate2) { FactoryGirl.build(:weight_based_calculator_rate,
                                  :calculator_id => calculator.id,
                                  :from_value => 8,
                                  :rate => 15) }

  context "without validation errors" do
    it "should not have validation errors with valid attributes" do
      expect(rate1).to be_valid
      rate1.save!
    end
  end

  context "with validation errors" do
    context "from_value" do
      it "should be entered" do
        rate1.from_value = nil
        expect(rate1).to_not be_valid
        expect(rate1).to have_at_least(1).errors_on(:from_value)
      end

      it "should not be blank" do
        rate1.from_value = ''
        expect(rate1).to_not be_valid
        expect(rate1).to have_at_least(1).errors_on(:from_value)
      end

      it "should be numeric" do
        rate1.from_value = 'foo'
        expect(rate1).to_not be_valid
        expect(rate1).to have_at_least(1).errors_on(:from_value)
      end

      it "should be greater than zero" do
        rate1.from_value = -10
        expect(rate1).to_not be_valid
        expect(rate1).to have_at_least(1).errors_on(:from_value)
      end

    end

    context "rate" do
      it "should be entered" do
        rate1.rate = nil
        expect(rate1).to_not be_valid
        expect(rate1).to have_at_least(1).errors_on(:rate)
      end

      it "should be numeric" do
        rate1.rate = 'foo'
        expect(rate1).to_not be_valid
        expect(rate1).to have_at_least(1).errors_on(:rate)
      end

      it "should be greater than zero" do
        rate1.rate = -10
        expect(rate1).to_not be_valid
        expect(rate1).to have_at_least(1).errors_on(:rate)
      end

    end

    context "find_rate" do
      it "should find nothing when there are no rates" do
        Spree::WeightBasedCalculatorRate.all.should have(0).records
        expect(Spree::WeightBasedCalculatorRate.find_rate(calculator.id, 10)).to be_nil
      end

      it "should find a valid rate (from a single entry)" do
        rate1.save!

        expect(Spree::WeightBasedCalculatorRate.all).to have(1).records
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
end
