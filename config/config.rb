class Billpay
  
  enable :sessions

  # Connect to Database or create it
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/billpay.db")

  # Make sure that dynos don't get starved by renegade processes
  use Rack::Timeout
  Rack::Timeout.timeout = 10

  set :root, File.join(File.dirname(__FILE__), "..")
  set :haml, :format => :html5 # default for Haml format is :xhtml

  # This method enables the ability for our forms to use the _method hack for
  # actual RESTful stuff.
  set :method_override, true

  use Rack::Flash

  use OmniAuth::Builder do
    provider :twitter, ENV["1JJdW2WUNVSK4cPkmC3EBQ"], ENV["C1paQCnKiXEk89MrJ8TRH26vqbrZH0WaBmmjZxYE"]
  end

end
