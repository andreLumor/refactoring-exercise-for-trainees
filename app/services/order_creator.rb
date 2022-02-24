class OrderCreator
  def self.call(cart, address_params)
    new.call(cart, address_params)
  end

  def call(cart, address_params)
    order = initialize_order(cart.user, address_params).decorate
    order.add_items(cart)
    return {success: false, errors: order_errors(order)} unless order.save
    { success: true, content: order } 
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

  def order_errors(order)
    order.errors.map(&:full_message).map { |message| { message: message } }
  end
end
