class Debt
	include DataMapper::Resource
	
	property :id,       Serial
	property :amount,   Integer
	property :owed_id,  Integer, :key => true
	property :owes_id,  Integer, :key => true
	
	belongs_to :bill
end