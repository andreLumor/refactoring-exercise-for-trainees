require 'rails_helper'

RSpec.describe OrderCreator do
  let(:address) { build(:address) }
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }

  it 'returns a order instance' do
    expect(OrderCreator.call(cart, address)[:content]).to be_valid
  end

  it 'Persists a order' do
    expect { OrderCreator.call(cart, address) }.to change { Order.count }.by(1)
  end
end
