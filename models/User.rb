class User
	require 'digest/md5'

  include DataMapper::Resource
	
	property :id,               Serial
  property :uid,              String
	property :name,             String
  property :last_name,        String
  property :first_name,       String
  property :username,         String
  property :image,            String
  property :email,            String
  property :perishable_token, String
	property :created_at,       DateTime
	property :updated_at,       DateTime

  has n, :friendships, :child_key => [ :source_id ]
  has n, :friends, self, :through => :friendships, :via => :target

  has n, :debts

  def set_perishable_token
    self.perishable_token = Digest::MD5.hexidigest( rand.to_s )
    save
  end

  def reset_perishable_token
    self.perishable_token = nil
    save
  end

  def facebook?
    has_authorization?(:facebook)
  end

  def facebook
    get_authorization(:facebook)
  end

  def has_authorization?(auth)
    a = Authorization.first(:provider => auth.to_s, :user_id => self.id)
    # Return false if not authenticated and true otherwise.
    !a.nil?
  end

  def get_authorization(auth)
    Authorization.first(:provider => auth.to_s, :user_id => self.id)
  end

  def url
    "/user/#{id}"
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
