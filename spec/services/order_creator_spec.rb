require 'rails_helper'

RSpec.describe OrderCreator, type: :model do
  let(:address) { build(:address) }
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }

  it "returns a order instance" do
    expect(OrderCreator.call(cart, user, address)[:content]).to be_valid
  end

  it "Persists a order" do
    expect { OrderCreator.call(cart, user, address) }.to change { Order.count }.by(1)
  end
end
