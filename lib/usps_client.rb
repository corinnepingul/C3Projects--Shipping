require 'active_shipping'

class ShippingClient
  def self.find_usps_rates(params_hash)
    set_shipping_variables(params_hash)

    usps = ActiveShipping::USPS.new(:login => ENV["USPS_USERNAME"])
    response = usps.find_rates(@origin, @destination, @packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return usps_rates
  end

  def self.find_fedex_rates(params_hash)
    set_shipping_variables(params_hash)

    fedex = ActiveShipping::FedEx.new(:login => ENV["FEDEX_LOGIN"],
                                    :password => ENV["FEDEX_PASSWORD"],
                                    :key => ENV["FEDEX_KEY"],
                                    :account => ENV["FEDEX_ACCOUNT"],
                                    :meter => ENV["FEDEX_LOGIN"],
                                    :test => true)
    response = fedex.find_rates(@origin, @destination, @packages)
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return fedex_rates
  end

  private

  def self.set_shipping_variables(params_hash)
    @origin = set_origin_location(params_hash)
    @destination = set_destination_location(params_hash)
    @packages = set_packages(params_hash)
  end

  def self.set_origin_location(params_hash)
    ActiveShipping::Location.new(:country => params_hash[:origin_country],
                                :state => params_hash[:origin_state],
                                :city => params_hash[:origin_city],
                                :zip => params_hash[:origin_zip])
  end

  def self.set_destination_location(params_hash)
    ActiveShipping::Location.new(:country => params_hash[:destination_country],
                                :state => params_hash[:destination_state],
                                :city => params_hash[:destination_city],
                                :zip => params_hash[:destination_zip])
  end

  def self.set_packages(params_hash)
    ActiveShipping::Package.new(params_hash[:package_weight],
                                params_hash[:packages_dimentions])
  end
end
