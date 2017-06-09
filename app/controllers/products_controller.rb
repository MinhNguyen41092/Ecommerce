class ProductsController < ApplicationController
  include ProductLib
  before_action :load_product, except: [:index, :new, :create]
  before_action :verify_admin, only: [:edit, :update, :destroy]
  before_action :load_categories, except: :destroy
  before_action :get_views, only: :show

  def index
    if params[:filter]
      @products = filter_products(params[:filter]).page(params[:page])
        .per Settings.items_per_pages
    else
      @products = products_search(params[:search]).order_newest.page(params[:page])
        .per Settings.items_per_pages
    end
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
      redirect_to products_path
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

  def load_categories
    @categories = Category.all
  end

  def product_params
    params.require(:product).permit :title, :description,
      :image_url, :price, category_ids: []
  end

  def get_views
    @product.impressions.create ip_address: request.remote_ip,
      user_id: current_user.id
    @product.update_attribute :views, impression_count(@product)
  end
end
