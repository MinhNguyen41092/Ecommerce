module ProductLib

  def products_search(search)
    if search
      Product.where("title || description || price LIKE ?", "%#{search}%")
    else
      Product.valid_products
    end
  end
end
