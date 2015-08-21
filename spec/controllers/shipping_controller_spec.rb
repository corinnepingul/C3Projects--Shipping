require 'rails_helper'
require 'support/vcr_setup'

RSpec.describe ShippingController, type: :controller do
  #how to test it's make a call the API when those are in the client?
  describe "GET 'rates_and_estimates'" do
    context "valid input" do
      before :each do
        VCR.use_cassette('calling shipping client') do
          products = [{
                      weight: 123,
                      length: 30,
                      width: 20
                    },
                    {
                      weight: 70,
                      length: 60,
                      width: 20
                    }]

          params =
                    {:origin => {
                            :country => "US",
                            :state => "CA",
                            :city => "Beverly Hills",
                            :zip => "90210"
                            },
                    :destination => {
                            :country => "US",
                            :state => "WA",
                            :city => "Seattle",
                            :zip => "98102"
                            },
                    :products => products}

          get :rates_and_estimates, params
        end
      end

      it "is successful" do
        expect(response.response_code).to eq 200
      end

      it "calls the #find_usps_rates and returns an array of shipping rates" do
        expect(assigns(:usps_rates)).to be_an_instance_of Array
      end

      it "includes 'USPS Priority Mail 2-Day' delivery option" do
        delivery = 'USPS Priority Mail 2-Day'
        # loops through response of usps shipping rates per delivery type
        # and returns an array with the selected array
        delivery_type = assigns(:usps_rates).select do |delivery_type|
          delivery_type.include?(delivery)
        end
        # pulls selected array out of larger array
        delivery_type = delivery_type.pop

        expect(delivery_type).to include(delivery)
        expect(delivery_type).to be_an_instance_of Array
        expect(delivery_type.length).to eq 3
      end

      it "calls the #find_fedex_rates and returns an array of shipping rates" do
        expect(assigns(:fedex_rates)).to be_an_instance_of Array
      end

      it "includes 'FedEx Ground Home Delivery' delivery option" do
        delivery = 'FedEx Ground Home Delivery'
        # loops through response of fedex shipping rates per delivery type
        # and returns an array with the selected array
        delivery_type = assigns(:fedex_rates).select do |delivery_type|
          delivery_type.include?(delivery)
        end
        # pulls selected array out of larger array
        delivery_type = delivery_type.pop

        expect(delivery_type).to include(delivery)
        expect(delivery_type).to be_an_instance_of Array
        expect(delivery_type.length).to eq 3
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      context "the returned json object" do
        before :each do
          @response = JSON.parse response.body
        end

        it "is an hash of delivery objects" do

          expect(@response).to be_an_instance_of Hash
          expect(@response.length).to eq 2
          expect(@response.keys).to include("usps", "fedex")
        end

        it "includes both usps and fedex delivery options and rates" do
          # expect(@response.map { |r| r.keys}.flatten.uniq.sort)
          # expect(@response.map(&:keys).flatten.uniq.sort).to eq keys
        end
      end
    end

    context "invalid input" do
      before :each do
        VCR.use_cassette('calling shipping client with invalid address') do
          products = [{
                      weight: 123,
                      length: 30,
                      width: 20
                    },
                    {
                      weight: 70,
                      length: 60,
                      width: 20
                    }]

          params =
                    {:origin => {
                            :country => "213",
                            :state => "asdf",
                            :city => "asdf",
                            :zip => "000asdf"
                            },
                    :destination => {
                            :country => "lknerf",
                            :state => "asdf",
                            :city => "Se",
                            :zip => "99999"
                            },
                    :products => products}

          get :rates_and_estimates, params
        end
      end

      it "is not successful" do
        expect(response.response_code).to eq 400
      end

      it "usps and fedex rates are nil" do
        expect(assigns(:usps_rates)).to eq nil
        expect(assigns(:fedex_rates)).to eq nil
      end

      context "the returned json object" do
        before :each do
          @response = JSON.parse response.body
        end

        it "is an empty hash" do

          expect(@response).to be_an_instance_of Hash
          expect(@response).to be {}
        end
      end
    end
  end

  describe "GET #order_complete" do
    let(:params_one) { { param_one: [], order_id: 1 } }
    let(:params_two) { { order_id: 1, shipping_method: "fedex" } }

    before(:each) do
      Log.save_to_log(params_one)
      post :order_complete, params_two
    end

    it "does not save another record when updating" do
      expect(Log.all.count).to eq 1
    end

    it "updates the shipping method" do
      expect(Log.first.delivery_method_chosen).to eq "fedex"
    end
  end
end
