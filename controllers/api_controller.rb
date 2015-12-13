require 'hirb'

class SmartibuyDynamo < Sinatra::Base

  helpers GoodsHelpers

  configure do
    Hirb.enable
    set :session_secret, 'smartibuyisgood'
    set :api_ver, 'api/v1'
  end

  configure :development, :test do
    set :api_server, 'http://localhost:9292'
  end

  configure :production do
    set :api_server, 'http://smartibuyweb.herokuapp.com'
  end

  configure :production, :development do
    enable :logging
  end

  helpers do
    def current_page?(path = ' ')
      path_info = request.path_info
      path_info += ' ' if path_info == '/'
      request_path = path_info.split '/'
      request_path[1] == path
    end
  end

  # ==========
  # API Routes
  # ==========

  show_service_state = lambda do
    'Hello, This is Smartibuy web service. <br>' \
    'Hope you will enjoy your shoping!<br>'\
    "Current API version is #{settings.api_ver}<br>"\
    'See Homepage at <a href="https://github.com/Smartibuy">' \
    'Github repo</a><br> It\'s in ' << ENV['RACK_ENV'] << ' mode.'
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


  get_product = lambda do
    content_type :json
    begin
      product = Product.find(params[:id])
      product_title = product.product_title
      product_id = product.product_id
      fb_user_id = product.fb_user_id
      product_information = product.product_information
      price = product.price
      group_id = product.group_id

      logger.info({ product_title: product.product_title,
                    product_id: product.product_id,
                    fb_user_id: product.fb_user_id,
                    product_information: product.product_information,
                    price: product.price,
                    group_id: product.group_id}.to_json)
    rescue
      halt 400
    end
    { product_title: product.product_title,
                  product_id: product.product_id,
                  fb_user_id: product.fb_user_id,
                  product_information: product.product_information,
                  price: product.price,
                  group_id: product.group_id }.to_json
  end

  create_product = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue
      halt 400
    end
    product = Product.new(product_id: req['product_id'],
                        fb_user_id: req['fb_user_id'],
                        product_title: req['product_title'],
                        product_information: req['product_information'],
                        price: req['price'],
                        group_id: req['group_id'],
                        pic_url: req['pic_url'],
                        update_time: req['update_time'],
                        create_time: req['create_time'],
                        created_at: req['created_at'],
                        updated_at: req['updated_at'])

    if product.save
      status 201
      redirect "/api/v1/product/#{product.id}", 303
    else
      halt 500, 'Failed to save product.'
    end
  end

  search_mobile01 = lambda do
    content_type :json
    begin
      shopee_worker = ShopeeWorker.new
    rescue
      halt 400
    end
    puts params[:cate]
    shopee_worker.search_by_name_cate(params[:cate], params[:name], params[:num]).to_json
  end

  get '/api/state', &show_service_state
  get '/api/v1/fb_data/:id.json', &show_group_goods
  post '/api/v1/fb_data/search', &search_good

  get '/api/v1/group/:id', &get_group
  post '/api/v1/create_group', &create_group

  get '/api/v1/product/:id', &get_product
  post '/api/v1/create_product', &create_product

  # shopee
  get '/api/v1/search_mobile01/:cate/:name/:num/result.json', &search_mobile01

  # # =============
  # # Web UI Routes
  # # =============
  #
  # app_get_root = lambda do
  #   slim :home
  # end
  #
  # app_get_group = lambda do
  #   # for 清交二手貨倉, id is 817620721658179.
  #   request_url = "#{settings.api_server}/#{settings.api_ver}/fb_data/" << params[:id] << ".json"
  #   results = HTTParty.get(request_url)
  #   @goodlist = results
  #   slim :goods_info
  # end
  #
  # app_post_group =lambda do
  #   request_url = "#{settings.api_server}/#{settings.api_ver}/create_group"
  #
  #   form = CreateGroupForm.new(params)
  #   result = CreateGroupFromAPI.new(request_url, form).call
  #   if (result.code != 200)
  #     flash[:notice] = 'Could not found service'
  #     redirect '/group'
  #     return nil
  #   end
  #
  #   redirect "/group/#{result.group_id}"
  # end
  #
  # create_group = lambda do
  #   slim :creategroup
  # end
  #
  # search = lambda do
  #   slim :search
  # end
  #
  # search_good_by_group = lambda do
  #   group_id = params[:group_id]
  #   puts 'group id: ' << group_id
  #   redirect "/group/#{group_id}"
  # end
  #
  # # Web App Views Routes
  # get '/', &app_get_root
  # get '/group/:id' , &app_get_group
  # post '/group' ,&app_post_group
  # get '/group', &create_group
  # get '/search', &search
  # post '/search', &search_good_by_group

end
