class PurchaseService
  def self.call(purchase_params)
    new.call(purchase_params)
  end

  def call(purchase_params)
    return { success: false, errors: gateway_error } unless gateway_valid?(purchase_params)
    cart = CartCreator.call(purchase_params.slice(:cart_id, :user))
    return { success: false, errors: cart[:errors] } unless cart[:success]
    order = OrderCreator.call(cart[:content], address_params(purchase_params))
    return { success: false, errors: order[:errors] } unless order[:success]
    return { success: true, order: order[:content] }
  end

  private
  def gateway_error
    [{ message: 'Gateway not supported!' }]
  end

  SUPPORTED_GATEWAYS = ['stripe', 'paypal']
  def gateway_valid?(purchase_params)
    SUPPORTED_GATEWAYS.include? purchase_params[:gateway]
  end

  def address_params(purchase_params)
    purchase_params[:address] || {}
  end
end
