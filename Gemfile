source 'http://rubygems.org'
ruby '2.2.3'

# gems for internal operations
gem 'thin'
gem 'sinatra'
gem 'sinatra-contrib'
# Product
gem 'secondHandler'
gem 'shopee'

gem 'fuzzy-string-match'
gem 'json'
gem 'httparty'

gem 'activesupport'
gem 'concurrent-ruby-ext'

# gems requiring credentials for 3rd party services
gem 'config_env'
gem 'aws-sdk', '~> 2'     # DynamoDB (Dynamoid), SQS Message Queue
gem 'dynamoid', '~> 1'
gem 'dalli'               # Memcachier

group :test do
  gem 'minitest'
  gem 'rack'
  gem 'rack-test'
  gem 'rake'
  gem 'minitest'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'tux'
end
