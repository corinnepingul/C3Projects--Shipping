require 'active_shipping'

class ShippingController < ApplicationController

  def shipping_costs
    packages = ActiveShipping::Package.new(110, [93, 10], oversized: false)
    origin = ActiveShipping::Location.new(:country => 'US',
                                          :state => 'WA',
                                          :city => 'Seattle',
                                          :zip => '98102')
    destination = ActiveShipping::Location.new(:country => 'US',
                                          :state => 'CA',
                                          :city => 'Beverly Hills',
                                          :zip => '90210')
    login = ENV["USPS_USERNAME"]

    usps = ActiveShipping::USPS.new(:login => login)

    response = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    raise
  end

  # def delivery_estimate


  # end


  # def tracking


  # end


end
