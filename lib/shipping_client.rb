require 'active_shipping'

class ShippingClient
  # OPTIMIZE: think about how to combine some methods

  def self.find_usps_rates(params)

    set_shipping_variables(params)

    usps = ActiveShipping::USPS.new(:login => ENV["USPS_USERNAME"])
    response = usps.find_rates(@origin, @destination, @packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return usps_rates
  end

  def self.find_fedex_rates(params)
    set_shipping_variables(params)

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

  def self.fedex_shipping_estimate

  end

  def self.usps_shipping_estimate

  end

  def self.fedex_tracking_info

  end

  def self.usps_tracking_info

  end

  private

  def self.set_shipping_variables(params)

    @origin = set_origin_location(params)
    @destination = set_destination_location(params)
    @packages = set_packages(params)

  end

  def self.set_origin_location(params)
    ActiveShipping::Location.new(params[:origin])
  end

  def self.set_destination_location(params)
    ActiveShipping::Location.new(params[:destination])
  end

  def self.set_packages(params)
    products = params[:products] # This will be our array of data
    packages = products.map do |product|
      ActiveShipping::Package.new(product[:weight].to_i,
                                  [product[:length].to_i, product[:width].to_i])
    end

    return packages
  end
end
