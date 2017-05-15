class UsersController < ApplicationController
  before_action :load_user, only: :show
  before_action :require_logged_in, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :index

  def index; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "users.create"
      redirect_to root_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.update"
      redirect_to user_path @user
    else
      render :edit
    end
  end

  def destroy
    @user = User.find_by id: params[:id]
    if @user.destroy
      flash[:success] = t "users.deleted"
      redirect_back
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "users.no_user"
    redirect_to root_path
  end

  def require_logged_in
    unless logged_in?
      flash[:danger] = t "users.pls_log_in"
      redirect_to login_path
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    if @user != current_user
      flash[:danger] = t "users.not_correct_user"
      redirect_to root_path
    end
  end

  def admin_user
    if !current_user.is_admin
      flash[:danger] = t "users.not_admin"
      redirect_to root_path
    end
  end

  def redirect_back
    if current_user.is_admin
      redirect_to users_path
    else
      redirect_to root_path
    end
  end
end
