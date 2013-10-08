class Authorization < ActiveRecord::Base
  belongs_to :user
  has_many :keys
  after_save :load_keys, unless: Proc.new { |auth| auth.name.nil? }

  def load_keys
  end

end
