require_relative 'spec_helper'
require 'json'

describe 'Checking create product' do
  before do
    Product.delete_all
  end

  header = { 'CONTENT_TYPE' => 'application/json' }
  body = {
    "product_id"=> "914934681926782",
    "fb_user_id"=> "000000000000000",
    "product_title"=> "surface 4 pro",
    "product_information"=> "《使用次數》全新，因為買錯了，想賣出",
    "price"=> "40000",
    "group_id"=> "000000000000000",
    "pic_url"=> "https://compass-ssl.surface.com/assets/fb/55/fb55676b-0995-46ad-8107-dda48123b181.jpg?n=Hero-panel-image-gallery_02.jpg",
    "update_time"=> "2015-11-08T12:05:36+0000",
    "create_time"=> "2015-11-08T12:05:36+0000",
    "created_at"=> "facebook",
    "updated_at"=> "facebook",
  }

  it 'should return vaild url' do

    post '/api/v1/create_product', body.to_json, header

    #check response code
    last_response.must_be :redirect?

    #check location format
    next_location = last_response.location
    next_location.must_match %r{http:\/\/example.org\/api\/v1\/product\/\w+}
  end

  it 'should return bad request' do

    post '/api/v1/create_product', "", header

    #check response code
    last_response.must_be :bad_request?

  end
end
