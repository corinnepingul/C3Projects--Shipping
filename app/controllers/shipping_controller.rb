require 'carrier_client'

class ShippingController < ApplicationController

  def rates
    @usps_rates = CarrierClient.find_usps_rates(params)
    @fedex_rates = CarrierClient.find_fedex_rates(params)

    rates = {usps: @usps_rates, fedex: @fedex_rates}

    render json: rates
  end

  def estimates

  end

  def order_complete(params)
    ShippingOrder.create_shipping_order(params)
    Package.create_packages(session[:products])
  end
end
