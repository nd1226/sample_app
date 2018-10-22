class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new)
  before_action :load_user, except: %i(create new index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def show; end

  def edit; end

  def new
    @user = User.new
  end

  def index
    @users = User.activated.paginate page: params[:page],
      per_page: Settings.user.per_page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.new.check_mail"
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.edit.profile_update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy.user_delete"
    else
      flash[:danger] = t "users.destroy.delete_fail"
    end
    redirect_to users_path
  end

  private
  def no_user
    render file: "#{Rails.root}/public/no_user.html", layout: false, status: 404
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    no_user
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users.edit.require_login"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
