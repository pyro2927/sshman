class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :key_id
      t.string :public_key
      t.string :url
      t.string :name
      t.boolean :verified
      t.references :authorization, index: true

      t.timestamps
    end
  end
end
