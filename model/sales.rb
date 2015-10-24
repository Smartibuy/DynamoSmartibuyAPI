require 'second_handler'
require 'json'


class Goods
  attr_reader :id, :message
  def initialize(id=nil)
    @id = id
    @message = load_Info_by_id(id)
  end

  def load_Info_by_id(id)
    fb = SecondHandler::FbGroupPost.new('1517291225230751|o7NH0AUs5hiQRZpCTq2Q_9gZf0w', id)
    page = fb.first_page
  end

  def to_jsonlist
    result = []
    message.each do |good|
      element = {}
      element['ID'] = good['id']
      element['刊登時間'] = good['updated_time']
      element['商品資訊'] = good['message']
      result << element
    end
    result.to_json
  end
end
