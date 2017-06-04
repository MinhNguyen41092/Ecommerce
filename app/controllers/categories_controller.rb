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

  def edit; end

  def update
    if @category.update category_params
      flash[:success] = t "categories.updated"
      redirect_to products_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "categories.deleted"
      redirect_to products_path
    else
      flash[:danger] = t "categories.not_deleted"
      redirect_to :back
    end
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