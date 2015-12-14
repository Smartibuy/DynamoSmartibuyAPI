require 'dynamoid'

class Group
  include Dynamoid::Document
  field :group_id, :string
  field :group_name, :string

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
