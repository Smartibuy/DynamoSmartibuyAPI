require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext'
require 'hirb'

require 'config_env'
require 'aws-sdk'
require 'dalli'

class SmartibuyDynamo  < Sinatra::Base
  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/../config/config_env.rb")

    set :api_server, 'http://localhost:9292'
  end

  configure :development do
    # ignore if not using shotgun in development
    set :session_secret, "fixed secret"
  end

  configure do
    Hirb.enable
    set :session_secret, 'smartibuyisgood'
    set :api_ver, 'api/v1'
  end

  configure :production do
    set :api_server, 'http://smartibuyapidynamo.herokuapp.com'
  end

  configure do
    set :cadet_cache, Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
      {:username => ENV["MEMCACHIER_USERNAME"],
        :password => ENV["MEMCACHIER_PASSWORD"],
        :socket_timeout => 1.5,
        :socket_failure_delay => 0.2
        })
    set :cadet_cache_ttl, 1.day    # 24hrs

    set :cadet_queue, Aws::SQS::Client.new(region: ENV['AWS_REGION'])
    set :cadet_queue_name, 'RecentCadet'
  end

  configure :production, :development do
    enable :logging
  end

  before do
    @HOST_WITH_PORT = request.host_with_port
  end
end
