class Member
	include DataMapper::Resource
	
	property :id,            Serial
	property :name,          String
	property :age,           Integer
	property :username,      String
	property :bio,           Text
	property :email,         String
	property :created_at,    DateTime
	property :updated_at,    DateTime
	
	has n, :friendships, :child_key => [:starter_id]
	has n, :friends, self, :through => :friendships, :via => :target
end
