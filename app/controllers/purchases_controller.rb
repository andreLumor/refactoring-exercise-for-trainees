class PurchasesController < ApplicationController
  def create
    response = PurchaseService.call(purchase_params)
    if response.class == Order
      return render json: { status: :success, order: { id: response.id } }, status: :ok
    else
      return render json: {errors: response}, status: :unprocessable_entity
    end
  end

  def purchase_params
    params.permit(
      :gateway,
      :cart_id,
      user: %i[email first_name last_name],
      address: %i[address_1 address_2 city state country zip]
    )
  end
end
