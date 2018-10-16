class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.sent_reset"
      redirect_to root_path
    else
      flash.now[:danger] = t "password_resets.email_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("password_resets.cant_empty"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "password_resets.password_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user)
          .permit :password, :password_confirmation
  end

  def no_user
    render file: "#{Rails.root}/public/no_user.html", layout: false, status: 404
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user
    no_user
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "user_mailer.password_reset.has_exprired"
    redirect_to new_password_reset_path
  end
end
