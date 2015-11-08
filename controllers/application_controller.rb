require 'sinatra/base'
require_relative '../models/sale'

class ApplicationController < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

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

  show_service_state = lambda do
    'Hello, This is Smartibuy service. <br>' \
    'Hope you will enjoy your shooping!<br>'\
    'Current API version is v1.<br>'\
    'See Homepage at <a href="https://github.com/Smartibuy/SecondHand-ler">' \
    'Github repo</a>'
  end

  show_group_goods = lambda do
    content_type :json
    get_all_information(params[:id]).to_jsonlist
  end

  search_good = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
    rescue
      halt 400
    end
    get_good(req['group_id'], req['good_id']).to_json
  end

  get_group = lambda do
    content_type :json
    begin
      group = Group.find(params[:id])
      group_name = group.group_name
      group_id = group.group_id
      logger.info({ id: group.id, group_name: group_name, group_id: group_id }.to_json)
    rescue
      halt 400
    end
    { id: group.id, group_name: group_name, group_id: group_id }.to_json
  end

  create_group = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue
      halt 400
    end
    group = Group.new(group_id: req['group_id'], group_name: req['group_name'])

    if group.save
      status 201
      redirect "/api/v1/group/#{group.id}", 303
    else
      halt 500, 'Failed to save group.'
    end
  end
  get '/', &show_service_state
  get '/api/v1/fb_data/:id.json', &show_group_goods
  post '/api/v1/fb_data/search', &search_good

  get '/api/v1/group/:id', &get_group
  post '/api/v1/create_group', &create_group
end
