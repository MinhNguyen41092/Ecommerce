class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def verify_admin
    if logged_in?
      if !current_user.is_admin
        flash[:danger] = t "users.not_admin"
        redirect_to root_path
      end
    else
      flash[:danger] = t "users.pls_log_in"
      redirect_to root_path
    end
  end
end
