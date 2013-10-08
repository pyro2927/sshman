class GithubAuthorization < Authorization

  def create_local_key_from_hash(k)
    new_key = Key.find_or_initialize_by_key_id(k.id)
    new_key.update_attributes({public_key: k[:key], name: k.title, authorization: self, key_id: k.id}) 
  end

  def load_keys
    github = Github.new oauth_token: token
    keys = github.users.keys.all name
    keys.each { |k| create_local_key_from_hash k }
  end

  def clone_key(existing_key)
    github = Github.new oauth_token: token
    new_key = github.users.keys.create title: existing_key.name, key: existing_key.public_key
    create_local_key_from_hash new_key unless new_key.nil?
  end

end
