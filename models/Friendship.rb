class Friendship
	include DataMapper::Resource
	
	property :balance, Integer

	property :target_id, Integer, :key => true, :min => 1
	property :starter_id, Integer, :key => true, :min => 1

	belongs_to :starter, 'Member', :key => true
	belongs_to :target, 'Member', :key => true
end