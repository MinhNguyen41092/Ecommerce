class PagesController < ApplicationController
  include Statistics

  def home; end
  def about; end
  def news; end

  def statistics
    product_orders

    purchased_products
  end
end
