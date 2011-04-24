require 'rubygems'
require 'bundler'

Bundler.require

require 'billpay.rb'

run Sinatra::Application
