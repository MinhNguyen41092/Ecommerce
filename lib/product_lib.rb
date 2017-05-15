module ProductLib

  def products_search search
    if search
      Product.where("title || description || price LIKE ?", "%#{search}%")
    else
      Product.valid_products
    end
  end

  def rating product
    if !product.average(t("rating")).nil?
      product.update_attribute :ratings, product.average(t("rating")).avg
    end
    product.ratings
  end

  def filter_products filter
    if filter == t("filter.all")
      Product.valid_products
    elsif filter == t("filter.most_viewed")
      Product.valid_products.most_viewed
    elsif filter == t("filter.rating")
      Product.valid_products.rating
    elsif filter == t("filter.oldest")
      Product.valid_products.order_oldest
    elsif filter == t("filter.newest")
      Product.valid_products.order_newest
    elsif filter == t("filter.alph")
      Product.valid_products.alph
    elsif filter == t("filter.price_high_to_low")
      Product.valid_products.price_high_to_low
    elsif filter == t("filter.price_low_to_high")
      Product.valid_products.price_low_to_high
    end
  end
end
