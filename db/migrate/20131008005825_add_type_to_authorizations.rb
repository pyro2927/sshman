class AddTypeToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :type, :string
  end
end
