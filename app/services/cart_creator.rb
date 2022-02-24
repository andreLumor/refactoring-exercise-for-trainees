class CartCreator
  def self.call(purchase_params)
    new.call(purchase_params)
  end

  def call(purchase_params)
    cart = Cart.find_by(id: purchase_params[:cart_id])
    return { success: false, errors: not_found_error } unless cart
    if cart.user.nil?
      user_params = purchase_params[:user] || {}
      cart.user = User.create(**user_params.merge(guest: true))
      return { success: false, errors: user_errors(cart.user) } unless cart.user.valid?
    end
    return { success: true, content: cart }
  end

  def not_found_error
    [{ message: 'Cart not found!' }]
  end

  def user_errors(user)
    user.errors.map(&:full_message).map { |message| { message: message } }
  end
end
