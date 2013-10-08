class KeysController < ApplicationController
  def destroy
    key = Key.find(params[:id])
    user = key.authorization.user
    key.authorization.delete_key key
    redirect_to user
  end
end
