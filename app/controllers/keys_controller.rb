class KeysController < ApplicationController
  def destroy
    key = Key.find(params[:id])
    case key.authorization.provider
    when "Github"
    when "Bitbucket"
    end
    user = key.authorization.user
    key.destroy
    redirect_to user
  end
end
