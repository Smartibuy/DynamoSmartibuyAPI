require_relative 'spec_helper'
require 'json'

describe 'Getting group ID goods' do
  # it 'Should return ok' do
  #   VCR.use_cassette('valid_fb_group') do
  #     get "/api/v1/fb_data/#{SECOND_HAND_GID}.json"
  #   end
  #   last_response.must_be :ok?
  # end
  #
  # it 'Should return not found' do
  #   VCR.use_cassette('empty_fb_group') do
  #     get "/api/v1/fb_data/#{EMPTY_SECOND_HAND_GID}.json"
  #   end
  #   last_response.must_be :not_found?
  # end
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
    next_location.must_match %r{http:\/\/example.org\/api\/v1\/group\/\w+}
  end

  it 'should return bad request' do

    post '/api/v1/create_group', '', header

    #check response code
    last_response.must_be :bad_request?

  end
end
