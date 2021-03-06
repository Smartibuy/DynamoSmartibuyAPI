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

  get_mobile01_products = lambda do
    content_type :json
    begin
      puts params[:cate], params[:page]
      shopee_worker = ShopeeWorker.new
      if params[:page].nil?
        products = shopee_worker.get_mobile01_products(params[:cate])
      else
        products = shopee_worker.get_mobile01_products(params[:cate], params[:page])
      end

      products.to_json
    rescue
      halt 400
    end
  end

  get_cate_childs = lambda do
      content_type :json
      shopee_worker = ShopeeWorker.new
      shopee_worker.get_cate_childs(params[:cate]).to_json
  end

  add_keyword_into_search_queue = lambda do
    keyword = params[:keyword]
    queue_search.enqueue(keyword)
  end

  read_group_post = lambda do
    content_type :json
    list = get_all_information(params[:id], params[:timestamp], params[:page])
    list.read_current_page_json
  end

  read_good_post = lambda do
    content_type :json
    logger.info params[:good_id]
    logger.info params[:token]
    logger.info params[:action]
    one_good = get_one_good(params[:good_id])
    one_good.good_info_json
  end

  read_good_comments = lambda do
    content_type :json
    logger.info params[:good_id]
    logger.info params[:token]
    logger.info params[:action]
    one_good = get_one_good(params[:good_id], params[:token], params[:action])
    one_good.comments_json
  end

  get_all_shops = lambda do
    content_type :json
    get_all_shops_json
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
                                 cate: cate_data)
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
                                 key: key_data)
    if hot_key_data.save
     status 201
    else
      halt 500, 'Failed to save keyword.'
    end
  end

  get_hot_data = lambda do
    begin
      if params[:type] == 'keyword'
        index = Hot_Keyword.all.map do |t|
          { key: t.key, time: t.time,
            created_at: t.created_at, updated_at: t.updated_at }
        end
      else
        index = Hot_Cate.all.map do |t|
          { cate: t.cate, time: t.time,
            created_at: t.created_at, updated_at: t.updated_at }
        end
      end
    rescue
      halt 400
    end

    index.to_json

  end

  save_user_info = lambda do
    content_type :json

    begin
      req = JSON.parse(request.body.read)
    rescue
      puts errors
      halt 400
    end

    user_id = params[:id]
    email = req['email']
    hashtag = req['hashtag'].nil? ? [] : req['hashtag']

    puts params[:id], email

    user_a = User.where(:id => user_id).all

    if user_a[0] == nil
      user_data = User.new(id: user_id, email: email, hashtag: hashtag)
      if user_data.save
        status 201
      else
        halt 500, 'Failed to save keyword.'
      end
    end
  end

  get_user_info = lambda do
    content_type :json, charset: 'utf-8'
    user_a = User.where(:id => params[:id]).all
    index = {}
    if user_a[0] != nil
      index['id'] =  user_a[0].id
      index['email'] = user_a[0].email
      index['hashtag'] = user_a[0].hashtag
      index.to_json
    else
      halt 404, 'There is no this user info.'
    end
  end

  get_all_user_info = lambda do
    content_type :json, charset: 'utf-8'
    users = User.all
    if not users.nil?
      data = users.map do |user|
        {
          "id" => user.id,
          "email" => user.email,
          "hashtag" =>  user.hashtag
        }
      end
      {"data" => data}.to_json
    else
      halt 404, 'There is no  user info.'
    end
  end

  add_user_hashtag = lambda do
    begin
      data = JSON.parse(request.body.read)
    rescue
      halt 400
    end

    data["id"] = params[:id]

    form = UpdateUserTagForm.new(data)
    if form.valid?
      target = User.find(params[:id])

      if target.nil?
        halt 404, "account not found!!!"
      end

      if target.hashtag.nil?
        target.hashtag = [form.tag]
      elsif target.hashtag.include? form.tag
        halt 409, "tag has been exist"
      else
        target.hashtag << form.tag
      end

      target.save
    else
      halt 400, "failed to read #{form.error_fields} param(s)"
    end
  end

  del_user_hashtag = lambda do

    form = UpdateUserTagForm.new(params)
    if form.valid?
      target = User.find(params[:id])

      if target.nil?
        halt 404, "account not found!!!"
      end

      if target.hashtag.nil?
        halt 409, "no this tag"
      elsif target.hashtag.include? form.tag
        target.hashtag.delete(form.tag)
      else
        halt 409, "no this tag"
      end

      target.save
    else
      halt 400, "failed to read #{form.error_fields} param(s)"
    end
  end
  send_digest_mail = lambda do
      template = ""
      user_list = User.all

      puts user_list
      template_path = File.expand_path("../layout/contents.slim", File.dirname(__FILE__))
      # template = ""
      user_list.each do |user|
         data = Array.new
         if not user.hashtag.nil?
           user.hashtag.each do |tag|
             begin
                shopee_worker = ShopeeWorker.new
                puts "taging read ... #{tag}"
                info = shopee_worker.get_mobile01_products(tag)


                data << {
                    "tag"=> tag,
                    "contents" => info
                  }
              rescue
                logger.warn "no data"
              end



          end
          if not data.empty?
            require 'slim'
            require 'mailgun'
            puts template_path
            parameters = {
                :name => user["id"],
                :data => data
            }
            template = Slim::Template.new(template_path).render(Object.new, parameters)

            mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"]

                  # Define your message parameters
            message_params = {:from    => 'no-reply@mg.smartibuy.top',
                              :to      =>  user["email"],
                              :subject => 'Smartibuy 給您專屬於您的最新好物',
                              :html    => template}

            # Send your message through the client
            mg_client.send_message "mg.smartibuy.top", message_params
          end
         end
      end
      template
  end
  get '/', &show_service_state
  get '/api/v1/fb_data/:id.json', &show_group_goods
  post '/api/v1/fb_data/search', &search_good

  get '/api/v1/fb_data/goods/:good_id', &read_good_post
  get '/api/v1/fb_data/goods/:good_id/comments', &read_good_comments
  get '/api/v1/fb_data/:id/goods', &read_group_post
  get '/api/v1/fb_data/shops', &get_all_shops

  get '/api/v1/group/:id', &get_group
  post '/api/v1/create_group', &create_group

  get '/api/v1/product/:id', &get_product
  post '/api/v1/create_product', &create_product

  # shopee
  get '/api/v1/search_mobile01/:cate/:name/:num/result.json', &search_mobile01
  get '/api/v1/mobile01/:cate', &get_mobile01_products
  get '/api/v1/mobile01_child/:cate', &get_cate_childs

  # enqueue
  post '/api/v1/add_keyword_to_search_queue/:keyword', &add_keyword_into_search_queue
  post '/api/v1/add_keyword_to_cate_queue/:cate', &add_keyword_into_cate_queue

  # post the hot keyword
  post '/api/v1/save_hot_key_word', &save_hot_keyword
  post '/api/v1/save_hot_cate', &save_hot_cate

  get '/api/v1/hot/:type', &get_hot_data

  #update&get user data
  post '/api/v1/users/:id/tags/', &add_user_hashtag
  post '/api/v1/users/:id', &save_user_info
  delete '/api/v1/users/:id/tags/:tag', &del_user_hashtag

  get '/api/v1/users/', &get_all_user_info
  get '/api/v1/users/:id', &get_user_info
  post '/api/v1/mails' ,&send_digest_mail

end
