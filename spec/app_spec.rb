require_relative 'spec_helper'
require 'json'

describe 'Getting the root of the service' do
  it 'Should return ok' do
    get '/'
    last_response.must_be :ok?
  end
end



describe 'Getting group ID goods' do
  it 'Should return ok' do
    VCR.use_cassette('valid_fb_group') do
      get "/api/v1/fb_data/#{SECOND_HAND_GID}.json"
    end
    last_response.must_be :ok?
  end
  
  it 'Should return not found' do
    VCR.use_cassette('empty_fb_group') do
      get "/api/v1/fb_data/#{EMPTY_SECOND_HAND_GID}.json"
    end
    last_response.must_be :not_found?
  end
end

describe 'Searchind with group ID and goods' do
  
  it 'should return ok' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = { 
      "group_id" => SECOND_HAND_GID,
      "good_id" => VAILD_GOOD_ID
    }
    VCR.use_cassette('valid_fb_search') do
      post '/api/v1/fb_data/search', body.to_json, header
    end
    last_response.must_be :ok?
  end
  
  it 'should return bad request for bad format' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = VAILD_GOOD_ID
    VCR.use_cassette('invalid_fb_search') do
      post '/api/v1/fb_data/search', body.to_json, header
    end
    last_response.must_be :bad_request?
  end
end

describe 'Checking create group' do
  before do
    Group.delete_all
  end
  
  header = { 'CONTENT_TYPE' => 'application/json' }
  body = { 
      "group_id" => "201511082300",
      "group_name" => "smartibuy is good"
  }

  it 'should return vaild url' do
    
    post '/api/v1/create_group', body.to_json, header
    
    #check response code
    last_response.must_be :redirect?
    
    #check location format
    next_location = last_response.location
    next_location.must_match %r{api\/v1\/group\/\d+}
  end
  
  it 'should return bad request' do
    
    post '/api/v1/create_group', '', header
    
    #check response code
    last_response.must_be :bad_request?
    
  end
end


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
    next_location.must_match %r{api\/v1\/product\/\d+}
  end
  
  it 'should return bad request' do
    
    post '/api/v1/create_product', "", header
    
    #check response code
    last_response.must_be :bad_request?
    
  end
end