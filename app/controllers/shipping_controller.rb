require 'carrier_client'

class ShippingController < ApplicationController

  def rates_and_estimates
    @usps_rates = CarrierClient.find_usps_rates(params)
    @fedex_rates = CarrierClient.find_fedex_rates_and_estimates(params)

    Log.save_to_log(params)

    rates = {usps: @usps_rates, fedex: @fedex_rates}

    render json: rates
  end

  def order_complete

    Log.update_log(params)

    render :nothing => true
  end
end
