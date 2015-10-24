require 'sinatra/base'
require_relative './model/sales'

class SmartibuyApp < Sinatra::Base

  helpers do
    def get_all_information(id)
      Goods.new(id)
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
end
