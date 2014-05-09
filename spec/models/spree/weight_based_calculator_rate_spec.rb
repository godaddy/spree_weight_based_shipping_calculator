require 'spec_helper'

describe Spree::WeightBasedCalculatorRate do
  before(:all) do
    @shipping_method = FactoryGirl.create(:shipping_method)
    @calculator = FactoryGirl.create(:weight_based_shipping_calculator)
  end

  let(:rate1) { FactoryGirl.build(:weight_based_calculator_rate,
                                  :calculator_id => @calculator.id,
                                  #:calculator_type => @calculator.class.to_s,
                                  :from_value => 0,
                                  :rate => 10) }
  let(:rate2) { FactoryGirl.build(:weight_based_calculator_rate,
                                  :calculator_id => @calculator.id,
                                  #:calculator_type => @calculator.class.to_s,
                                  :from_value => 8,
                                  :rate => 15) }

  context "without validation errors" do
    it "should not have validation errors with valid attributes" do
      rate1.should be_valid
      rate1.save!
    end
  end

  context "with validation errors" do
    context "from_value" do
      it "should be entered" do
        rate1.from_value = nil
        rate1.should_not be_valid
        rate1.errors_on(:from_value).should_not be_blank
      end

      it "should not be blank" do
        rate1.from_value = ''
        rate1.should_not be_valid
        rate1.errors_on(:from_value).should_not be_blank
      end

      it "should be numeric" do
        rate1.from_value = 'foo'
        rate1.should_not be_valid
        rate1.errors_on(:from_value).should_not be_blank
      end

      it "should be greater than zero" do
        rate1.from_value = -10
        rate1.should_not be_valid
        rate1.errors_on(:from_value).should_not be_blank
      end

      it "should be unique" do
        rate1.save!

        rate2.from_value = 0
        rate2.should_not be_valid
        rate2.errors_on(:from_value).should_not be_blank
      end
    end

    context "rate" do
      it "should be entered" do
        rate1.rate = nil
        rate1.should_not be_valid
        rate1.errors_on(:rate).should_not be_blank
      end

      it "should be numeric" do
        rate1.rate = 'foo'
        rate1.should_not be_valid
        rate1.errors_on(:rate).should_not be_blank
      end

      it "should be greater than zero" do
        rate1.rate = -10
        rate1.should_not be_valid
        rate1.errors_on(:rate).should_not be_blank
      end

    end

    context "find_rate" do
      it "should find nothing when there are no rates" do
        Spree::WeightBasedCalculatorRate.all.should have(0).records
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 10).should be_nil
      end

      it "should find a valid rate (from a single entry)" do
        rate1.save!

        Spree::WeightBasedCalculatorRate.all.should have(1).records
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 0).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 0.1).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 1).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 50).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 99).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 99.9).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 100).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 200.1).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, -5).should be_nil
      end

      it "should find a valid rate (from two entries)" do
        rate1.save!
        rate2.save!

        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 0).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 0.1).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 1).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 3).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 7.9).should == 10
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 8).should == 15
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 8.1).should == 15
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 100.1).should == 15
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 101).should == 15
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 499).should == 15
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 499.9).should == 15
        Spree::WeightBasedCalculatorRate.find_rate(@calculator.id, 500).should == 15
      end
    end
  end
end
