class OrdersController < ApplicationController
  include CartOrder
  before_action :set_cart, only: [:new, :create]
  before_action :check_cart_status, only: :new
  before_action :verify_admin, only: [:index, :update, :destroy]
  before_action :load_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.all.newest
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params
    add_line_items_to_order @cart, @order
    @order.user = current_user
    if @order.save
      Cart.destroy session[:cart_id]
      session[:cart_id] = nil
      send_mail @order
      flash[:success] = t "orders.submitted"
      redirect_to products_path
    else
      render :new
    end
  end

  def show; end

  def update
    if @order.update update_order_status
      flash[:success] = t "orders.updated"
    else
      flash[:danger] = t "orders.not_updated"
    end
    send_mail @order
    redirect_to :back
  end

  def destroy
    if @order.destroy
      flash[:success] = t "orders.deleted"
    else
      flash[:danger] = t "orders.not_deleted"
    end
    redirect_to :back
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order
    flash[:danger] = t "orders.not_found"
    redirect_to orders_path
  end

  def order_params
    params.require(:order).permit :full_name, :email, :address, :pay_type
  end

  def update_order_status
    params.require(:order).permit :status
  end
end
