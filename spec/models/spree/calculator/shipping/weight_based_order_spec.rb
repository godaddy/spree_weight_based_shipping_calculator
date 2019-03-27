RSpec.describe Spree::Calculator::Shipping::WeightBasedOrder do
  before(:all) do
    @shipping_method = FactoryBot.create(:shipping_method)
  end

  let(:calculator) { FactoryBot.build(:weight_based_shipping_calculator) }

  let(:rate1) { FactoryBot.build(:weight_based_calculator_rate,
                                  from_value: 0,
                                  rate: 10) }
  let(:rate2) { FactoryBot.build(:weight_based_calculator_rate,
                                  from_value: 8,
                                  rate: 15) }
  let(:rate3) { FactoryBot.build(:weight_based_calculator_rate,
                                  from_value: 20,
                                  rate: 25) }

  let(:variant1) { double(Spree::Variant,
                          weight: 3,
                          width:  1,
                          depth:  1,
                          height: 1,
                          price:  2)
                  }
  let(:variant2) { double(Spree::Variant,
                          weight: 4,
                          width:  1,
                          depth:  1,
                          height: 1,
                          price:  5)
                  }

  let(:empty_package) { double(Spree::Stock::Package, order: mock_model(Spree::Order), contents: []) }
  let(:package_with_one_item) { double(Spree::Stock::Package, order: mock_model(Spree::Order),
                                       contents: [Spree::Stock::Package::ContentItem.new(nil, variant1, 2)]) }
  let(:package_with_two_item) { double(Spree::Stock::Package, order: mock_model(Spree::Order),
                                       contents: [Spree::Stock::Package::ContentItem.new(nil, variant1, 2),
                                                  Spree::Stock::Package::ContentItem.new(nil, variant2, 3)]) }

  it { should have_many(:rates)}


  context "there are no items in the package" do
    before(:each) do
      calculator.rates << rate1
      calculator.save!
      expect(empty_package.contents.length).to eq(0)
    end

    it "returns zero" do
      rate = calculator.compute_package(empty_package)
      expect(rate).to eq(0)
    end

    it "is not available" do
      expect(calculator.available?(empty_package)).to be false
    end
  end

  context "There are more than one items in the package" do
    before(:each) do
      calculator.rates << rate1
      calculator.rates << rate2
      calculator.rates << rate3
      calculator.save!
    end

    it "calculates correct rate for one item with zero weight" do
      allow(package_with_one_item.contents[0].variant).to receive(:weight).and_return(0)

      rate = calculator.compute_package(package_with_one_item)
      expect(rate).to eq(10)
    end

    it "calculates correct rate for one item with total weight 6" do
      rate = calculator.compute_package(package_with_one_item)
      expect(rate).to eq(10)
    end

    it "calculates correct rate for two items with total weight 18" do
      rate = calculator.compute_package(package_with_two_item)
      expect(rate).to eq(15)
    end

    it "calculates correct rate for two items with total weight 18" do
      allow(package_with_two_item.contents[0].variant).to receive(:weight).and_return(10)

      rate = calculator.compute_package(package_with_one_item)
      expect(rate).to eq(25)
    end

  end

  context "with validation errors" do
    it "has no rate configured" do
      expect(calculator).to_not be_valid
    end

    it "has duplicate weight configured" do
      calculator.rates << rate1
      rate2.from_value = 0
      calculator.rates << rate2
      expect(calculator).to_not be_valid
    end
  end

end
