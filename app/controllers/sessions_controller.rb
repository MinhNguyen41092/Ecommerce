class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "You have logged in successfully"
      redirect_to root_path
    else
      flash[:danger] = "Incorrect email or password"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "You are logged out"
    redirect_to root_path
  end
end
