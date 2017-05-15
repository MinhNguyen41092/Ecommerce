module LineItemsHelper

  def total_price item
    item.price * item.quantity
  end
end
