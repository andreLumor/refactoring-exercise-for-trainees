require 'rails_helper'

RSpec.describe OrderDecorator do
  let(:cart) { create(:cart) }
  let(:sale) { create(:sale, unit_price_cents: 500) }
  let(:item) { create(:cart_item, cart: cart, sale: sale, quantity: 2) }
  let(:order) { create(:order).decorate }

  describe '#add_items' do
    it 'Adds cart items to order' do
      cart.items << item
      order.add_items(cart)
      expect(order.items.count).to eq(2)
    end
  end
end
