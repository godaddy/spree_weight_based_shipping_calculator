require 'spec_helper'

describe Spree::Calculator::Shipping::WeightBasedOrder do
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
  let(:rate3) { FactoryGirl.build(:weight_based_calculator_rate,
                                  :calculator_id => @calculator.id,
                                  #:calculator_type => @calculator.class.to_s,
                                  :from_value => 20,
                                  :rate => 25) }

  let(:variant1) { double(Spree::Variant,
                          weight: 3,
                          width: 1,
                          depth: 1,
                          height: 1,
                          price: 2) }
  let(:variant2) { double(Spree::Variant,
                          weight: 4,
                          width: 1,
                          depth: 1,
                          height: 1,
                          price: 5) }

  let(:empty_package) { double(Spree::Stock::Package, order: mock_model(Spree::Order), contents: []) }
  let(:package_with_one_item) { double(Spree::Stock::Package, order: mock_model(Spree::Order),
                                       contents: [Spree::Stock::Package::ContentItem.new(variant1, 2)]) }
  let(:package_with_two_item) { double(Spree::Stock::Package, order: mock_model(Spree::Order),
                                       contents: [Spree::Stock::Package::ContentItem.new(variant1, 2),
                                                  Spree::Stock::Package::ContentItem.new(variant2, 3)]) }

  #let(:empty_order) { FactoryGirl.create(:order) }
  #let(:order_with_one_item) { FactoryGirl.create(:order_with_one_item) }

  context "there are no items in the package" do

    before(:each) do
      empty_package.contents.length.should == 0
    end

    it "returns zero" do
      rate = @calculator.compute_package(empty_package)
      rate.should == 0
    end

    it "is not available" do
      @calculator.available?(empty_package).should be_false
    end
  end

  context "There are one items in the package" do
    before(:each) do
      rate1.save!
      rate2.save!
      rate3.save!
    end

    it "calculates correct rate for one item with zero weight" do
      package_with_one_item.contents[0].variant.stub(weight: 0)

      rate = @calculator.compute_package(package_with_one_item)
      rate.should == 10
    end

    it "calculates correct rate for one item with total weight 6" do
      rate = @calculator.compute_package(package_with_one_item)
      rate.should == 10
    end

    it "calculates correct rate for two items with total weight 18" do
      rate = @calculator.compute_package(package_with_two_item)
      rate.should == 15
    end

    it "calculates correct rate for two items with total weight 18" do
      package_with_two_item.contents[0].variant.stub(weight: 10)

      rate = @calculator.compute_package(package_with_one_item)
      rate.should == 25
    end

  end


end