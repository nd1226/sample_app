class UsersController < ApplicationController
  def no_user
    render file: "#{Rails.root}/public/no_user.html", layout: false, status: 404
  end

  def show
    @user = User.find_by id: params[:id]
    no_user unless @user.presence
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "static_pages.home.home"
      redirect_to @user
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end
end
