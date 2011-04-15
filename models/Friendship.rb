class Friendship
	include DataMapper::Resource
	
  belongs_to :source, 'Member', :key => true
  belongs_to :target, 'Member', :key => true
end
