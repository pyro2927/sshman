# taken from: https://gist.github.com/schleg/993566
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require "uuidtools"

  def github
    oauthorize "Github"
  end

  def bitbucket
    oauthorize "Bitbucket"
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

private
  def oauthorize(kind)
    @user = find_for_oauth(kind, env["omniauth.auth"], current_user)
    if @user
      flash[:success] = "Sign in success"
      sign_in_and_redirect @user
    end
  end

  def find_for_oauth(provider, access_token, resource=nil)
    user, email, name, uid, auth_attr = nil, nil, nil, {}
    # pull the important information from our omniauth response
    uid = access_token['uid']
    name = access_token['info']['name']
    auth_attr = {:uid => uid, :token => access_token.credentials.token, :secret => access_token.credentials.secret, :name => access_token.info.nickname}

    # some providers don't give us a direct profile link
    case provider
    when "Bitbucket"
      auth_attr[:link] = "https://bitbucket.com/" + access_token.uid
      auth_attr[:name] = access_token.uid
    else
      auth_attr[:link] = access_token.info.urls[provider] 
    end


    # resource is existing user account
    if resource.nil?
      if email
        user = find_for_oauth_by_email(email, resource)
      elsif uid && name
        user = find_for_oauth_by_uid(uid, resource)
        if user.nil?
          user = find_for_oauth_by_name(name, resource)
        end
      end
    else
      user = resource
    end
   
    auth = user.authorizations.find_by_provider(provider)
    if auth.nil?
      auth = user.authorizations.build(:provider => provider)
      user.authorizations << auth
    end
    auth.type = provider + "Authorization"
    auth.update_attributes auth_attr

    user
  end

  def find_for_oauth_by_uid(uid, resource=nil)
    user = nil
    if auth = Authorization.find_by_uid(uid.to_s)
      user = auth.user
    end
    user
  end

  def find_for_oauth_by_email(email, resource=nil)
    if user = User.find_by_email(email)
      user
    else
      user = User.new(:email => email, :password => Devise.friendly_token[0,20])
      user.save
    end
    user
  end

  def find_for_oauth_by_name(name, resource=nil)
    if user = User.find_by_name(name)
      user
    else
      user = User.new(:name => name, :password => Devise.friendly_token[0,20], :email => "#{UUIDTools::UUID.random_create}@host")
      user.save :validate => false
    end
    user
  end

end
