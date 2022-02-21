class PurchasesController < ApplicationController
  def create
    if gateway_valid?

      cart = Cart.find_by(id: cart_id)

      unless cart
        return render json: { errors: [{ message: 'Cart not found!' }] }, status: :unprocessable_entity
      end

      user = if cart.user.nil?
               user_params = purchase_params[:user] ? purchase_params[:user] : {}
               User.create(**user_params.merge(guest: true))
             else
               cart.user
             end

      if user.valid?
        order = OrderBuilder.build(cart, user, address_params)
        order.save

        if order.valid?
          return render json: { status: :success, order: { id: order.id } }, status: :ok
        else
          return render json: { errors: order.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity
        end
      else
        return render json: { errors: user.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity
      end
    else
      render json: { errors: [{ message: 'Gateway not supported!' }] }, status: :unprocessable_entity
    end
  end

  private
  SUPPORTED_GATEWAYS = ['stripe', 'paypal']
  def gateway_valid?
    SUPPORTED_GATEWAYS.include? purchase_params[:gateway]
  end

  def purchase_params
    params.permit(
      :gateway,
      :cart_id,
      user: %i[email first_name last_name],
      address: %i[address_1 address_2 city state country zip]
    )
  end

  def address_params
    purchase_params[:address] || {}
  end
end
