require 'sinatra/base'
require_relative './model/sales'

class SmartibuyApp < Sinatra::Base

  helpers do
    def get_all_information(id)
      Goods.new(id)
    rescue
      halt 404
    end
    def get_good(group_id, good_id)
      Goods.new(group_id).get_good_by_id(good_id)
    rescue
      halt 404
    end
  end

  get '/' do
    'Hello, This is Smartibuy service. <br>' \
    'Hope you will enjoy your shooping!<br>'\
    'Current API version is v1.<br>'\
    'See Homepage at <a href="https://github.com/Smartibuy/SecondHand-ler">' \
    'Github repo</a>'
  end

  get '/api/v1/all_data/:id' do
    content_type :json
    get_all_information(params[:id]).to_jsonlist
  end

  post '/api/v1/data/search' do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
    rescue
      halt 400
    end
    get_good(req['group_id'], req['good_id']).to_json

  end
end
