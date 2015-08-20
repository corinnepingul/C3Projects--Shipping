class ShippingOrder < ActiveRecord::Base
  # Associations----------------------------------------------------------
  has_many :packages

  def self.create_shipping_order(origin, destination, params)
    order = self.new

    order.origin_country = session[:origin][:country]
    order.origin_state = session[:origin][:state]
    order.origin_city = session[:origin][:city]
    order.origin_zip = session[:origin][:zip]
    order.destination_country = session[:destination][:country]
    order.destination_state = session[:destination][:state]
    order.destination_city = session[:destination][:city]
    order.destination_zip = session[:destination][:zip]
    order.order_id = params[:order_id]
    order.delivery_method = params[:shipping_method]

    order.save
  end
end

