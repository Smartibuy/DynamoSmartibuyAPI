require 'sinatra'
require 'sinatra/activerecord'
require_relative '../config/environments'

class Product < ActiveRecord::Base
end
