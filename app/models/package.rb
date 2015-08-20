class Package < ActiveRecord::Base
  # Associations----------------------------------------------------------
  belongs_to :shipping_order

  def self.create_packages(products)
    order = ShippingOrder.last
    id = order.id

    products.each do |product|
      package = Package.new

      package.weight = session[:product][:weight]
      package.length = session[:product_length]
      package.width = session[:product_width]
      package.order_id = id
      package.save
    end
  end
end
