class Authorization < ActiveRecord::Base
  belongs_to :user
  has_many :keys
  after_save :load_keys, unless: Proc.new { |auth| auth.name.nil? }

  def load_keys
    case provider
    when "Github"
      github = Github.new oauth_token: token
      keys = github.users.keys.all name
      keys.each { |k| new_key = Key.find_or_initialize_by_key_id(k.id); new_key.update_attributes({public_key: k[:key], name: k.title, authorization: self, key_id: k.id}) }
    when "Bitbucket"
      bitbucket = BitBucket.new oauth_token: token, oauth_secret: secret, client_id: ENV['BITBUCKET_KEY'], client_secret: ENV['BITBUCKET_SECRET']
      keys = bitbucket.users.account.keys name
      keys.each { |k| new_key = Key.find_or_initialize_by_key_id(k.pk); new_key.update_attributes({public_key: k["key"], name: k.label, authorization: self}) }
    end
  end

end
