require 'carrier_client'

class ShippingController < ApplicationController

  def rates_and_estimates
    @usps_rates = CarrierClient.find_usps_rates(params)
    @fedex_rates = CarrierClient.find_fedex_rates_and_estimates(params)

    # These would be nil if the request was bad
    if @usps_rates == nil || @fedex_rates == nil
      render json: {}, status: 400
    else
      Log.save_to_log(params)
      rates = {usps: @usps_rates, fedex: @fedex_rates}

      render json: rates
    end
  end

  def order_complete

    Log.update_log(params)

    render :nothing => true
  end
end
