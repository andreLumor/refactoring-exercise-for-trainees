class OrderDecorator < Draper::Decorator
  delegate_all

  def add_items(cart)
    cart.items.each do |item|
      item.quantity.times do
        self.items << OrderLineItem.new(
          order: self,
          sale: item.sale,
          unit_price_cents: item.sale.unit_price_cents,
          shipping_costs_cents: shipping_costs(),
          paid_price_cents: item.sale.unit_price_cents + shipping_costs()
        )
      end
    end
  end

  def shipping_costs
    100
  end
end
