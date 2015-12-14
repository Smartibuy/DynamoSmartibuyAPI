require_relative 'spec_helper'
require 'json'

describe 'Searching with group ID and goods' do

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
