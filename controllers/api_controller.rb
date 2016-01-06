require 'sinatra/base'

class SmartibuyDynamo < Sinatra::Base
  queue_search = Queue_for_search.new
  queue_cate = Queue_for_cate.new

  helpers GoodsHelpers

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
    'See Homepage at <a href="https://github.com/Smartibuy/DynamoSmartibuyAPI">' \
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
      group_a = Group.where(:group_id => params[:id]).all
      group = group_a[0]
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

  add_keyword_into_search_queue = lambda do
    keyword = params[:keyword]
    queue_search.enqueue(keyword)
  end

  read_group_post = lambda do
    list = get_all_information(params[:id], params[:timestamp], params[:page])
    list.read_current_page_json
  end

  add_keyword_into_cate_queue = lambda do
    cate = params[:cate]
    queue_cate.enqueue(cate)
  end

  save_hot_cate = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue
      halt 400
    end

    time_stamp = Time.now.to_s
    cate_data = req['cate_data']
    hot_cate_data = Hot_Cate.new(time: time_stamp,
                                 cate: cate_data.to_s)
    if hot_cate_data.save
     status 201
    else
      halt 500, 'Failed to save keyword.'
    end
  end

  save_hot_keyword = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue
      halt 400
    end

    time_stamp = Time.now.to_s
    key_data = req['key_data']
    hot_key_data = Hot_Keyword.new(time: time_stamp,
                                 key: key_data.to_s)
    if hot_key_data.save
     status 201
    else
      halt 500, 'Failed to save keyword.'
    end
  end

  get '/', &show_service_state
  get '/api/v1/fb_data/:id.json', &show_group_goods
  post '/api/v1/fb_data/search', &search_good

  get '/api/v1/fb_data/:id/goods', &read_group_post

  get '/api/v1/group/:id', &get_group
  post '/api/v1/create_group', &create_group

  get '/api/v1/product/:id', &get_product
  post '/api/v1/create_product', &create_product

  # shopee
  get '/api/v1/search_mobile01/:cate/:name/:num/result.json', &search_mobile01

  # enqueue
  post '/api/v1/add_keyword_to_search_queue/:keyword', &add_keyword_into_search_queue
  post '/api/v1/add_keyword_to_cate_queue/:cate', &add_keyword_into_cate_queue

  # post the hot keyword
  post '/api/v1/save_hot_key_word', &save_hot_keyword
  post '/api/v1/save_hot_cate', &save_hot_cate



end
