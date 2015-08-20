class Log < ActiveRecord::Base

  def self.save_to_log(params)
    log = Log.new

    log.request = params
    log.client_order_id = params[:order_id]

    log.save
  end

  def self.update_log(params)
    log = Log.find_by(client_order_id: params[:order_id])

    log.delivery_method_chosen = params[:shipping_method]

    log.save
  end
end
