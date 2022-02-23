class CartDecorator < cart
  attr_acessor :cart
  def initialize(cart)
    @cart = cart
  end

  def list_items
    items = []
    @cart.items.each do |item|
      item.quantity.times do
        items.append(item)
      end
    end
    items
  end
end
