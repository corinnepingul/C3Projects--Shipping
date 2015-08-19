require 'shipping_client'

class ShippingController < ApplicationController

  def index
    # TODO: When done hardcoding, delete line 7-18
    data = {
      :origin_country => 'US',
      :origin_state => 'WA',
      :origin_city => 'Seattle',
      :origin_zip => '98102',
      :destination_country => 'US',
      :destination_state => 'CA',
      :destination_city => 'Beverly Hills',
      :destination_zip => '90210',
      :package_dimentions => [93,10],
      :package_weight => 110,
      :products => [{ weight: 110, length: 100, width: 20 }, { weight: 50, length: 10, width: 5 }]
    }
    params_hash = data

    @usps_rates = ShippingClient.find_usps_rates(params_hash)
    @fedex_rates = ShippingClient.find_fedex_rates(params_hash)
    rates = {usps: @usps_rates, fedex: @fedex_rates}

    render json: rates
  end
end
