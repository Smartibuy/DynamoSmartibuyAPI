require 'dynamoid'

class Hot_Cate
  include Dynamoid::Document
  field :time, :string
  field :cate, :string

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
