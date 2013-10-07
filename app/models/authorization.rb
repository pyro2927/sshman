class Authorization < ActiveRecord::Base
  belongs_to :user
  has_many :keys
  after_save :load_keys, unless: Proc.new { |auth| auth.name.nil? }

  def load_keys
    case provider
    when "Github"
      github = Github.new oauth_token: token
      keys = github.users.keys.all name
      keys.each { |k| Key.create({public_key: k[:key], name: k.title, authorization: self}) }
    when "Bitbucket"
      bitbucket = BitBucket.new oauth_token: token, oauth_secret: secret, client_id: ENV['BITBUCKET_KEY'], client_secret: ENV['BITBUCKET_SECRET']
      keys = bitbucket.users.account.keys name
      keys.each { |k| Key.create({public_key: k["key"], name: k.label, authorization: self}) }
    end
  end

end
