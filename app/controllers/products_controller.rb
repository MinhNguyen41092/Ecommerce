class ProductsController < ApplicationController
  before_action :load_product, except: [:index, :new, :create]
  before_action :verify_admin, only: [:edit, :update, :destroy]

  def index
    @products = Product.valid_products.order_newest.page(params[:page]).
      per Settings.items_per_pages
    @cart = Cart.find_by id: session[:cart_id]
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    @product.user = current_user
    if @product.save
      flash[:success] = t "products.create"
      redirect_to root_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @product.update product_params
      flash[:success] = t "products.update"
      redirect_to product_path @product
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t "products.deleted"
      redirect_to products_path
    else
      render :show
    end
  end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:danger] = t "products.no_product"
    redirect_to products_path
  end

  def product_params
    params.require(:product).permit :title, :description, :image_url, :price
  end
end
