class OrderCreator
  def self.call(cart, user, address_params)
    new.call(cart, user, address_params)
  end
  def call(cart, user, address_params)
    order = Order.new(
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

    cart.items.each do |item|
      item.quantity.times do
        order.items << OrderLineItem.new( #mais factory?
          order: order,
          sale: item.sale,
          unit_price_cents: item.sale.unit_price_cents,
          shipping_costs_cents: shipping_costs(),
          paid_price_cents: item.sale.unit_price_cents + shipping_costs()
        )
      end
    end
    order.save
    order
  end
  private
  def shipping_costs
    100
  end
end
