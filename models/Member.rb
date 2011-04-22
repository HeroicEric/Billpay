class Member
	include DataMapper::Resource
	
	property :id,            Serial
	property :name,          String
	property :created_at,    DateTime
	property :updated_at,    DateTime

  has n, :friendships, :child_key => [ :source_id ]
  has n, :friends, self, :through => :friendships, :via => :target

  has n, :debts

  def url
    "/members/#{id}"
  end

  def add_friend(target_id)
    self.friendships << Friendship.create(:target_id => target_id)
    self.save
  end

  def balance_with(target_id)
    balance = 0

    debts(:with_id => target_id).each do |d|
      balance += d.amount
    end

    balance
  end

end
