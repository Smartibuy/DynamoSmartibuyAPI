require 'dynamoid'

class Product
  include Dynamoid::Document
  field :product_id, :string
  field :fb_user_id, :string
  field :product_title, :string
  field :product_information, :string
  field :price, :string
  field :group_id, :string
  field :pic_url, :string
  field :update_time, :string
  field :create_time, :string

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
