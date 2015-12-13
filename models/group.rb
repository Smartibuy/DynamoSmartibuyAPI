# require 'sinatra'
# require 'sinatra/activerecord'
# require_relative '../config/environments'
#
# class Group < ActiveRecord::Base
# end


require 'dynamoid'

class Group
  include Dynamoid::Document
  field :group_id, :string
  field :group_name, :string
end
