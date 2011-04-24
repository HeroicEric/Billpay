require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'haml'
require 'oa-oauth'
require 'rack-flash'

# Connect to Database or create it
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/billpay.db")

# Require data models
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }

use OmniAuth::Strategies::Facebook, '8b3600a5cb23553b471c74b1d040f6fa', '3e042c824c48f32a2bdbf14a29a82ef0'
use Rack::Flash

enable :sessions

helpers do
  def current_user
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user
  end

  def require_login!(opts = {:return => "/"})
    unless logged_in?
      flash[:error] = "Sorry, friend. You need to log in!"
      redirect opts[:return]
    end
  end
end

get '/' do
	if logged_in?
    haml :dashboard
  else
    haml :index
  end
end

get '/login/facebook' do
  redirect '/auth/facebook'
end

get '/auth/:name/callback' do
  auth = request.env["omniauth.auth"]
  user = User.first_or_create({ :uid => auth["uid"]}, { 
    :uid => auth["uid"], 
    :username => auth["user_info"]["nickname"],
    :name => auth["user_info"]["name"],
    :email => auth["user_info"]["email"],
    :last_name => auth["user_info"]["last_name"],
    :first_name => auth["user_info"]["first_name"]
    # TODO: This doesn't let user be created/saved for some reason.
    # In testing, Users can't be saved with URL as :img
    # :image => auth["user_info"]["image"]
  })
  
  session[:user_id] = user.id
  redirect '/user/' + user.id.to_s
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

#########################################
## USERS ################################
#########################################

# List all users
get '/users' do
	@users = User.all
	haml :users
end

# Add a new user
get '/user/new' do
	@user = User.new
	haml :user_new
end

# Create a new user
post '/user/new' do
	@user = User.create(params[:user])
	if @user.save
		status 201
		redirect '/user/' + @user.id.to_s
	else
		status 400
		haml :users_new
	end
end

# View a user
get '/user/:id' do
  require_login!

  @user = User.get(params[:id])
  haml :user_profile
end

# Edit a user info
get '/users/edit/:id' do
	@user = User.get(params[:id])
	haml :user_edit
end

# Update user info
put '/users/edit/:id' do
	@user = User.get(params[:id])
	
	# If the params from the form match those of
	# a user
	if @user.update(params[:user])
		status 201
		redirect '/users/' + params[:id]
	else
		status 400
		haml :user_edit
	end
end

post '/user/friend' do
  user = User.get(params[:source_id])
  user.add_friend(params[:target_id])
  user.save

  redirect '/user/' + params[:source_id]
end

#########################################
## Bills ################################
#########################################

# Finalize and Initialize the Database
DataMapper.finalize
DataMapper::auto_migrate!
