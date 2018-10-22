class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    check_user user
  end

  def check_session user
    if params[:session][:remember_me] == Settings.user.remember_me
      remember user
    else
      forget user
    end
  end

  def check_activation user
    if user.activated?
      log_in user
      check_session user
      redirect_back_or user
    else
      flash[:warning] = t "activate.account_not_activated"
      redirect_to root_path
    end
  end

  def check_user user
    if user&.authenticate params[:session][:password]
      check_activation user
    else
      flash.now[:danger] = t "sessions.new.invalid_pass"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
