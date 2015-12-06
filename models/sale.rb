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
      element['attachments'] = good['attachments']
      begin
        element['attachments'] = element['attachments']['data'].first['media']['image']['src']
      rescue
        puts 'no images'
      end

      begin
        element['attachments'] = element['attachments']['data'].first['subattachments']['data'].first['media']['image']['src']
      rescue
        puts 'no images'
      end

      result << element
    end
    result.to_json
  end

  def get_good_by_id(good_id)
    element = {}
    message.each do |good|
      id = good['id']
      if id == good_id
        element['ID'] = good['id']
        element['刊登時間'] = good['updated_time']
        element['商品資訊'] = good['message']
      end
    end
    element
  end
end
