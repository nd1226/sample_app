class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "micropost.micropost_created"
      redirect_to root_path
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.delete_succes"
      redirect_to request.referrer || root_path
    else
      flash[:danger] = t "micropost.delete_fail"
    end
  end

  private
  def micropost_params
    params.require(:micropost)
          .permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_path if @micropost.nil?
  end
end
