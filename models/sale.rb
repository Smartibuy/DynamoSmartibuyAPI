require 'second_handler'
require 'json'


class Goods
  attr_reader :id, :page_token, :timestamp, :group
  def self.shops
    {"data" => SecondHandler.read_parsed_info('1517291225230751|o7NH0AUs5hiQRZpCTq2Q_9gZf0w')}.to_json
  end

  def initialize(id, page, timestamp)
    @id = id
    @page_token = page
    @timestamp = timestamp
    @group = SecondHandler::FbGroupPost.new('1517291225230751|o7NH0AUs5hiQRZpCTq2Q_9gZf0w', id)

  end

  def read_current_page_json

    if @page_token.nil? or  @timestamp.nil?
      @group.first_page
    else
      @group.specified_page(@page_token,@timestamp)
    end
    proccess_data.to_json

  end

  def proccess_data
    data = @group.get_content
    if data.empty?
      {
        "data" => [],
        "prev" => nil,
        "next" => nil,
      }
    else
      next_page = @group.next_page_params.last
      {
        "data" => data,
        "prev" => {},
        "next" => {
          "timestamp" => next_page["until"],
          "page" => next_page["__paging_token"]
        },
      }
    end

  end

  def to_jsonlist
    fb = SecondHandler::FbGroupPost.new('1517291225230751|o7NH0AUs5hiQRZpCTq2Q_9gZf0w', id)
    message = fb.first_page
    result = []
    message.each do |good|
      element = {}
      element['ID'] = 'https://www.facebook.com/groups/' << good['id'].split('_')[0] << '/permalink/' << good['id'].split('_')[1]
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
