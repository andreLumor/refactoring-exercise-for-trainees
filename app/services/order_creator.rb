class OrderCreator
  def self.call(cart, user, address_params)
    new.call(cart, user, address_params)
  end

  def call(cart, user, address_params)
    order = initialize_order(user, address_params).decorate
    order.add_items(cart)
    return {success: false, content: order} unless order.save
    {success: true, content: order} 
  end

  private
  def initialize_order(user, address_params)
    Order.new(
      user: user,
      first_name: user.first_name,
      last_name: user.last_name,
      address_1: address_params[:address_1],
      address_2: address_params[:address_2],
      city: address_params[:city],
      state: address_params[:state],
      country: address_params[:country],
      zip: address_params[:zip],
    )
  end
end
