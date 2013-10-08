class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    if params[:id]
      @user = User.find(params[:id]) 
    end
    @user ||= current_user
  end

  def merge_and_sync
    if params[:id]
      @user = User.find(params[:id]) 
    end
    @user ||= current_user
    @user.merge_and_sync
    redirect_to @user
  end

end
