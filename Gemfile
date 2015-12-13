source 'https://rubygems.org'
ruby '2.2.3'

gem 'sinatra'
gem 'json'

# Product
gem 'fuzzy-string-match'
gem 'secondHandler'
gem 'shopee'

gem 'activerecord'
gem 'sinatra-activerecord'
gem 'tux'
gem 'hirb'
gem 'virtus'

gem 'httparty'

gem 'sinatra-flash'
gem 'slim'
gem 'tilt'

gem 'config_env'
gem 'aws-sdk', '~> 2'    # DynamoDB, SQS Message Queue
gem 'dalli'               # Memcachier
gem 'dynamoid', '~> 1'

group :test, :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'rack'
  gem 'rake'
  gem 'rack-test'
  gem 'minitest'
  gem 'vcr'
  gem 'webmock'
end
