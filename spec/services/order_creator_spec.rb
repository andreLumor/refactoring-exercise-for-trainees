require 'rails_helper'

RSpec.describe OrderCreator, type: :model do
  let(:address_params) {{address_1: "", address_2: "", city: "", state: "", country: "", zip: ""}}
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }

  it "returns a order instance" do
    expect(OrderCreator.call(cart, user, address_params)).to be_valid
  end

  it "Persists a order" do
    expect { OrderCreator.call(cart, user, address_params) }.to change { Order.count }.by(1)
  end
end
