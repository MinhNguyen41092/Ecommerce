class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by email: params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == Settings.has_remember ?
        remember(user) : forget(user)
      flash[:success] = t "sessions.success"
      redirect_to user_path user
    else
      flash[:danger] = t "sessions.fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t "sessions.out"
    redirect_to root_path
  end
end
