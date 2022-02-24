require 'rails_helper'

RSpec.describe CartCreator do
  let!(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }
  let!(:cart_without_user) { create(:cart, user: nil) }
  let!(:params_user) { build(:user).attributes }

  it 'returns a cart if valid arguments' do
    expect(CartCreator.call({ cart_id: cart.id })[:content]).to eq(cart)   
  end

  it 'returns false if cart doesnt exist' do
    expect(CartCreator.call({ cart_id: -1 })[:success]).to eq(false)   
  end 

  context 'params have user' do
    it 'creates user if cart doesnt have one' do
      expect(CartCreator.call({ cart_id: cart_without_user.id, user: params_user })[:content].user).to be_valid  
    end
  end

  context 'params dont have user' do
    it 'returns {success: false}' do
      expect(CartCreator.call({ cart_id: cart_without_user.id })[:success]).to be_falsy
    end
  end
end
