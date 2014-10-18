$:.unshift(File.expand_path('lib/', File.dirname(__FILE__)))

require 'sinatra/activerecord'
require 'media_converter'
require 'workers'
