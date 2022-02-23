require 'rails_helper'

RSpec.describe PurchaseService, type: :model do
  let(:address) { build(:address) }
  let(:valid_user) { create(:user) }
  let(:cart) { create(:cart, user: valid_user) }
  subject {{gateway: "paypal", cart_id: cart.id, address: address}}

  context 'When parameters are valid' do
    it "returns order instance" do
      expect(PurchaseService.call(subject)[:success]).to be_truthy
    end
  end

  it "returns error message if gateway is invalid" do
    subject[:gateway] = ""
    expect(PurchaseService.call(subject)).to eq({success: false, errors: [{ message: 'Gateway not supported!' }]})
  end

  it "returns error message if cart doesn't exists" do
    subject[:cart_id] = -1
    expect(PurchaseService.call(subject)).to eq({success: false, errors: [{ message: 'Cart not found!' }]})
  end

  context "user is invalid" do
    let(:cart_with_invalid_user) { create(:cart, user: nil) }
    it "returns error message" do
      subject[:cart_id] = cart_with_invalid_user.id
      expect(PurchaseService.call(subject)).to eq({success: false, errors: [
                                                            { message: "Email can't be blank" },
                                                            { message: "First name can't be blank" },
                                                            { message: "Last name can't be blank" }
                                                          ]})
      end
  end
end
