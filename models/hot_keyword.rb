require 'dynamoid'

class Hot_Keyword
  include Dynamoid::Document
  field :time, :string
  field :key, :string

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
