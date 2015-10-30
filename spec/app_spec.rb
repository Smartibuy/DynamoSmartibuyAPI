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