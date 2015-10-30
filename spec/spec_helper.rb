ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'vcr'
require 'webmock/minitest'
require_relative '../app'

include Rack::Test::Methods

def app
  SmartibuyApp
end


VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

SECOND_HAND_GID = "817620721658179"
EMPTY_SECOND_HAND_GID = "0000000"
VAILD_GOOD_ID = "817620721658179_846628928757358"