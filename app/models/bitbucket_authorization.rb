class BitbucketAuthorization < Authorization

  def create_local_key_from_hash(k)
    new_key = Key.find_or_initialize_by_key_id(k.pk)
    new_key.update_attributes({public_key: k["key"], name: k.label, authorization: self}) 
  end

  def load_keys
    bitbucket = BitBucket.new oauth_token: token, oauth_secret: secret, client_id: ENV['BITBUCKET_KEY'], client_secret: ENV['BITBUCKET_SECRET']
    keys = bitbucket.users.account.keys name
    keys.each { |k| create_local_key_from_hash k }
  end

  def clone_key(existing_key)
    bitbucket = BitBucket.new oauth_token: token, oauth_secret: secret, client_id: ENV['BITBUCKET_KEY'], client_secret: ENV['BITBUCKET_SECRET']
    new_key = bitbucket.users.account.new_key name, {label: existing_key.name, key: existing_key.public_key}
    create_local_key_from_hash new_key unless new_key.nil?
  end

end
