module Statistics

  def product_orders
    @product_orders = []
    Product.all.each do |p|
      @product_orders << [p.title, p.orders.size/Order.shipped.size.to_f]
    end
    @product_orders
  end

  def purchased_products
    @purchased_products = []
    Product.all.each do |product|
      product_total_purchased = 0
      product.orders.shipped.each do |order|
        order.line_items.each do |item|
          next if item.product_id != product.id
          product_total_purchased += item.quantity
        end
      end
      @purchased_products << [product.title, product_total_purchased]
    end
  end
end