require 'shipping_client'

class ShippingController < ApplicationController

  def index
    # TODO: When done hardcoding, delete line 7-18
    # params = {
    #   :origin_country => 'US',
    #   :origin_state => 'WA',
    #   :origin_city => 'Seattle',
    #   :origin_zip => '98102',
    #   :destination_country => 'US',
    #   :destination_state => 'CA',
    #   :destination_city => 'Beverly Hills',
    #   :destination_zip => '90210',
    #   :package_dimentions => [93,10],
    #   :package_weight => 110
    # }
    params_hash = params

    @usps_rates = ShippingClient.find_usps_rates(params_hash)
    @fedex_rates = ShippingClient.find_fedex_rates(params_hash)
    rates = {usps: @usps_rates, fedex: @fedex_rates}

    render json: rates
  end
end
