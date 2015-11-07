class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :product_id
      t.string :fb_user_id
      t.string :product_title
      t.string :product_information
      t.integer :price
      t.string :group_id
      t.string :pic_url
      t.string :update_time
      t.string :create_time
      t.timestamps null:false
    end
  end
end
