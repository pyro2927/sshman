class Key < ActiveRecord::Base
  belongs_to :authorization

  def destroy
    case authorization.provider
    when "Github"
      #TODO: handle github key deletion
    when "Bitbucket"
      bitbucket = BitBucket.new oauth_token: authorization.token, oauth_secret: authorization.secret, client_id: ENV['BITBUCKET_KEY'], client_secret: ENV['BITBUCKET_SECRET']
      begin
        bitbucket.users.account.delete_key(authorization.name, key_id)
      rescue
        puts "Why is this returning a 404?!?!?"
      end
    end
    super destroy
  end
end
