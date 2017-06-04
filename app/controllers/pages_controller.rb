class PagesController < ApplicationController
  include Statistics
  before_action :verify_admin, only: :statistics

  def home; end
  def about; end
  def news; end

  def statistics
    product_orders

    purchased_products
  end
end
