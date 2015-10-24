require 'sinatra/base'

class SmartibuyApp < Sinatra::Base
  get '/' do
    'Hello, This is Smartibuy service. Hope you will enjoy your shooping!'
  end
end
