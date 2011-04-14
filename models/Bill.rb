class Bill
	include DataMapper::Resource
	
	property :id,                   Serial
	property :amount,               Integer
	property :title,                String
	property :description,          Text
	property :involved_members_ids, String
	property :created_at,           DateTime
	property :updated_at,           DateTime
	
	has n, :members
	has n, :debts
end
