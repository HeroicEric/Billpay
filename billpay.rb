require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'haml'

# Connect to Database or create it
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/billpay.db")

# Require data models
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }

get '/' do
	haml :index
end

#########################################
## MEMBERS ##############################
#########################################

# List all Members
get '/members' do
	@members = Member.all
	haml :members
end

# Add a new Member
get '/members/new' do
	@member = Member.new
	haml :members_new
end

# Create a new Member
post '/members/new' do
	@member = Member.create(params[:member])
	if @member.save
		status 201
		redirect '/members'
	else
		status 400
		haml :members_new
	end
end

# View a Member
get '/members/:id' do
	@member = Member.get(params[:id])
	haml :members_profile
end

# Edit a Member info
get '/members/edit/:id' do
	@member = Member.get(params[:id])
	haml :member_edit
end

# Update Member info
put '/members/edit/:id' do
	@member = Member.get(params[:id])
	
	# If the params from the form match those of
	# a Member
	if @member.update(params[:member])
		status 201
		redirect '/members/' + params[:id]
	else
		status 400
		haml :member_edit
	end
end

#########################################
## Friendship ###########################
#########################################

# Add a Friendship
get '/friendship/new' do
	@friendship = Friendship.new
	haml :friendship_new
end


#########################################
## Bills ################################
#########################################

# Finalize and Initialize the Database
DataMapper.finalize
DataMapper::auto_upgrade!
