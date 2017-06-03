module CartOrder

  def add_product product, cart
    current_item  = cart.line_items.find_by product_id: product.id
    if current_item
      current_item.quantity += 1
    else
      current_item = cart.line_items.build product_id: product.id
    end
    current_item
  end

  def send_mail order
    if order.status == t("orders.received")
      OrderMailer.received(order).deliver_later
    elsif order.status == t("orders.shipped")
      OrderMailer.shipped(order).deliver_later
    else
      OrderMailer.canceled(order).deliver_later
    end
  end

  def total_price item
    item.price * item.quantity
  end

  def add_line_items_to_order cart, order
    cart.line_items.each do |item|
      order.line_items << item
      item.cart_id = nil
    end
  end

  def total_cost order
    cost = 0
    order.line_items.each do |item|
      cost += item.price * item.quantity
    end
    cost
  end

  private

  def set_cart
    if logged_in?
      @cart = Cart.find_by id: session[:cart_id]
      return if @cart
      @cart = Cart.create user_id: current_user.id
      session[:cart_id] = @cart.id
    else
      flash[:danger] = t "carts.not_logged_in"
      redirect_to products_path
    end
  end

  def check_cart_status
    if @cart.line_items.empty?
      flash[:danger] = t "carts.empty"
      redirect_to products_path
    end
  end
end
