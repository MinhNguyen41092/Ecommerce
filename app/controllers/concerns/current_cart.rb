module CurrentCart

  private

  def set_cart
    @cart = Cart.find_by id: session[:cart_id]
    return if @cart
    @cart = Cart.create user_id: current_user.id
    session[:cart_id] = @cart.id
  end
end
