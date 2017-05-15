class CartsController < ApplicationController
  include CartOrder
  before_action :set_cart, only: :destroy
  before_action :load_cart, only: :show

  def show; end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    flash[:success] = t "carts.deleted"
    redirect_to products_path
  end

  private

  def load_cart
    @cart = Cart.find_by id: params[:id]
    return if @cart && @cart.user_id == current_user.id
    flash[:danger] = t "carts.not_cart"
    redirect_to root_path
  end
end
