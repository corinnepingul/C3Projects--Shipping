require 'carrier_client'

class ShippingController < ApplicationController

  def rates_and_estimates
    @usps_rates = CarrierClient.find_usps_rates(params)
    @fedex_rates = CarrierClient.find_fedex_rates_and_estimates(params)

    # These would be nil if the request was bad
    if @usps_rates == nil || @fedex_rates == nil
      render json: {}, status: 400
    else
      rates = {usps: @usps_rates, fedex: @fedex_rates}

      render json: rates
    end
  end

  def order_complete
    #betsy makes a call to another URI that sends over all the data for the
    # order again, but this time it posts and persists to the database


    # ShippingOrder.create_shipping_order(params)
    # Package.create_packages(params)

  end
end
