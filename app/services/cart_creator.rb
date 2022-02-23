class CartCreator
  def self.call(purchase_params)
    new.call(purchase_params)
  end

  def call(purchase_params)
    cart = Cart.find_by(id: purchase_params[:cart_id])
    return nil unless cart
    if cart.user.nil?
      user_params = purchase_params[:user] || {}
      cart.user = User.create(**user_params.merge(guest: true))
    end
    return cart
  end
end
