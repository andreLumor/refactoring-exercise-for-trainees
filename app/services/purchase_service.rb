class PurchaseService
  def self.call(purchase_params)
    new.call(purchase_params)
  end

  def call(purchase_params)
    return {success: false, errors: gateway_error} unless gateway_valid?(purchase_params)
    return {success: false, errors: cart_error} unless cart = CartCreator.call(purchase_params.slice(:cart_id, :user))
    user = cart.user
    return {success: false, errors: make_error(user)} unless user.valid?
    order = OrderCreator.call(cart, user, address_params(purchase_params))
    return {success: false, errors: make_error(order[:content])} unless order[:success]
    return {success: true, order: order[:content]}
  end

  private
  def make_error(instance)
    instance.errors.map(&:full_message).map { |message| { message: message } }
  end

  def cart_error
    [{ message: 'Cart not found!' }]
  end

  def gateway_error
    [{ message: 'Gateway not supported!' }]
  end

  SUPPORTED_GATEWAYS = ['stripe', 'paypal'] #usar strategy
  def gateway_valid?(purchase_params)
    SUPPORTED_GATEWAYS.include? purchase_params[:gateway]
  end

  def address_params(purchase_params)
    purchase_params[:address] || {}
  end
end
