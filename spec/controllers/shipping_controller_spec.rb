require 'rails_helper'

RSpec.describe ShippingController, type: :controller do
  #how to test it's make a call the API when those are in the client?
  describe "GET 'index'" do
    it "is successful" do
      get :index
      expect(response.response_code).to eq 200
    end

    it "calls the #find_usps_rates and returns an array of shipping rates" do
      get :index

      expect(assigns(:usps_rates)).to be_an_instance_of Array
    end

    it "includes 'USPS Priority Mail 2-Day' delivery option" do
      get :index

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
      expect(delivery_type.length).to eq 2
    end

    it "calls the #find_fedex_rates and returns an array of shipping rates" do
      get :index

      expect(assigns(:fedex_rates)).to be_an_instance_of Array
    end
  end
end
