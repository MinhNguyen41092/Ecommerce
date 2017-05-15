class CategoriesController < ApplicationController
  before_action :load_category, except: [:new, :create]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "categories.created"
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @products = @category.products.page(params[:page]).
      per Settings.items_per_pages
  end

  private

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = t "categories.not_found"
    redirect_to products_path
  end

  def category_params
    params.require(:category).permit :name, :parent_id
  end
end