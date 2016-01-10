require 'virtus'
require 'active_model'

class StringStripped < Virtus::Attribute
  def coerce(value)
    value.is_a?(String) ? value.strip : nil
  end
end

# Form object
class UpdateUserTagForm
  include Virtus.model
  include ActiveModel::Validations

  attribute :id, StringStripped
  attribute :tag, StringStripped
 

  validates :id, presence: true
  validates :tag, presence: true


  def error_fields
    errors.messages.keys.map(&:to_s).join(', ')
  end
end