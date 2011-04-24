class Debt
	include DataMapper::Resource
	
	property :id,       Serial
	property :amount,   Integer
  property :with_id,  Integer

  belongs_to :user
end
