require 'rails_helper'

RSpec.describe Log, type: :model do
  describe "#save_to_log(params)" do
    let(:params) { { param_one: [], order_id: 1 } }

    before(:each) do
      Log.save_to_log(params)
    end

    it "creates a record" do
      expect(Log.all.count).to eq 1
    end

    it "saves the request" do
      expect(Log.first.request).to eq params.to_s
    end

    it "saves the client order id" do
      expect(Log.first.client_order_id).to eq 1
    end
  end

  describe "#update_log(params)" do
    let(:params_one) { { param_one: [], order_id: 1 } }
    let(:params_two) { { order_id: 1, shipping_method: "fedex" } }

    before(:each) do
      Log.save_to_log(params_one)
      Log.update_log(params_two)
    end

    it "does not save another record when updating" do
      expect(Log.all.count).to eq 1
    end

    it "updates the shipping method" do
      expect(Log.first.delivery_method_chosen).to eq "fedex"
    end
  end
end
