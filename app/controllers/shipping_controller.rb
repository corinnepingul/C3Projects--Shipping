require 'shipping_client'

class ShippingController < ApplicationController

  def index
    @usps_rates = ShippingClient.find_usps_rates(params)
    @fedex_rates = ShippingClient.find_fedex_rates(params)
    rates = {usps: @usps_rates, fedex: @fedex_rates}

    render json: rates
  end
end
