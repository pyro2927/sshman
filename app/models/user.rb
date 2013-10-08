class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :authorizations, :dependent => :destroy

  def merge_and_sync
    authorizations.each do |auth|
      current_keys = auth.keys.map { |key| key.public_key.split(" ")[0..1].join(" ") } #make sure to compare the actual key, and not the email at the end if there 
      other_keys = Key.where.not(authorization: auth)
      # loop over our keys from other authorizations and add them in if they aren't in this auth
      other_keys.each do |missing_key|
        auth.clone_key missing_key unless current_keys.include? missing_key.public_key.split(" ")[0..1].join(" ")
      end
    end
  end

end
