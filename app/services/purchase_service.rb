class PurchaseService
  def self.call(purchase_params)
    return gateway_error unless gateway_valid?(purchase_params)
    return cart_error unless cart = CartCreator.call(purchase_params.slice(:cart_id, :user))
    user = cart.user
    return make_error(user) unless user.valid?
    order = OrderCreator.call(cart, user, address_params(purchase_params))
    order.save
    return make_error(order) unless order.valid?
    return order
  end

  private
  def self.make_error(instance)
    instance.errors.map(&:full_message).map { |message| { message: message } }
  end

  def self.cart_error
    [{ message: 'Cart not found!' }]
  end

  def self.gateway_error
    [{ message: 'Gateway not supported!' }]
  end
  
  private
  SUPPORTED_GATEWAYS = ['stripe', 'paypal'] #usar strategy
  def self.gateway_valid?(purchase_params)
    SUPPORTED_GATEWAYS.include? purchase_params[:gateway]
  end

  def self.address_params(purchase_params)
    purchase_params[:address] || {}
  end
end
