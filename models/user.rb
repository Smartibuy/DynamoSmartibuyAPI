require 'dynamoid'

class User
  include Dynamoid::Document
  field :id, :string
  field :email, :string
  field :hashtag, :set

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
