class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, :load_product, only: :create
  before_action :load_line_item, only: [:update, :destroy]

  def create
    @line_item = @cart.add_product @product
    @line_item.price = product.price
    if @line_item.save
      flash[:success] = t "line_items.create_success"
      redirect_to @line_item.cart
    else
      flash[:danger] = t "line_items.create_failed"
      redirect_to :back
    end
  end

  def update
    if @line_item.update line_items_params
      redirect_to :back
    else
      flash[:danger] = t "line_items.update_failed"
    end
  end

  def destroy
    if @line_item.destroy
      flash[:success] = t "line_items.update_deleted"
      redirect_to cart_path @cart
    else
      redirect_to :back
    end
  end

  private

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product
    flash[:danger] = t "line_items.not_product"
    redirect_to products_path
  end

  def load_line_item
    @line_item = LineItem.find_by id: params[:id]
    return if @line_item
    flash[:danger] = t "line_items.not_item"
    redirect_to products_path
  end

  def line_items_params
    params.require(:line_item).permit :quantity
  end
end
