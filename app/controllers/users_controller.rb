class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def merge_and_sync
    @user = User.find(params[:id])
    keys = []
    @user.authorizations.each do |auth|
      keys = keys | auth.keys
    end
  end

end
