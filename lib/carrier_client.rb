require 'active_shipping'

class CarrierClient
  def self.find_usps_rates(params)
    valid_variables = set_rate_variables(params)

    if valid_variables == true
      usps = login_usps
      begin
        response = usps.find_rates(@origin, @destination, @packages)
        usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}
      rescue
        return nil
      end
      return usps_rates
    else
      return nil
    end
  end

  def self.find_fedex_rates_and_estimates(params)
    valid_variables = set_rate_variables(params)

    if valid_variables == true
      fedex = login_fedex
      begin
        response = fedex.find_rates(@origin, @destination, @packages)
        fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}
      rescue
        return nil
      end
      return fedex_rates
    else
      return nil
    end
  end

  private

  def self.login_usps
    ActiveShipping::USPS.new(:login => ENV["USPS_USERNAME"])
  end

  def self.login_fedex
    ActiveShipping::FedEx.new(:login => ENV["FEDEX_LOGIN"],
                              :password => ENV["FEDEX_PASSWORD"],
                              :key => ENV["FEDEX_KEY"],
                              :account => ENV["FEDEX_ACCOUNT"],
                              :meter => ENV["FEDEX_LOGIN"],
                              :test => true)
  end

  def self.set_rate_variables(params)
    @origin = set_origin_location(params)
    @destination = set_destination_location(params)
    @packages = set_packages(params)

    if @origin.nil? || @destination.nil? || @packages.nil?
      return false
    else
      return true
    end
  end

  def self.set_origin_location(params)
    begin
      ActiveShipping::Location.new(params[:origin])
    rescue
      return nil
    end
  end

  def self.set_destination_location(params)
    begin
      ActiveShipping::Location.new(params[:destination])
    rescue
      return nil
    end
  end

  def self.set_packages(params)
    begin
      products = params[:products] # This will be our array of package data
      packages = products.map do |product|
        ActiveShipping::Package.new(product[:weight].to_i,
                                    [product[:length].to_i, product[:width].to_i])
      end

      return packages
    rescue
      return nil
    end
  end
end
