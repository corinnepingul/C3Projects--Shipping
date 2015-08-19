class ShippingOrder < ActiveRecord::Base
  # Associations----------------------------------------------------------
  has_many :packages

  def self.create_shipping_order(params)
    order = self.new

    order.origin_country = params[:origin_country]
    order.origin_state = params[:origin_state]
    order.origin_city = params[:origin_city]
    order.origin_zip = params[:origin_zip]
    order.destination_country = params[:destination_country]
    order.destination_state = params[:destination_state]
    order.destination_city = params[:destination_city]
    order.destination_zip = params[:destination_zip]

    order.save
  end
end

