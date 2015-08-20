class Package < ActiveRecord::Base
  # Associations----------------------------------------------------------
  belongs_to :shipping_order

  def self.create_packages(params)
    order = ShippingOrder.last
    id = order.id

    package = self.new

    package.weight = params[:package_weight]
    package.length = params[:package_length]
    package.width = params[:package_width]
    package.order_id = id

    package.save
  end
end
