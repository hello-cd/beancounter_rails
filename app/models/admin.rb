class Admin

  attr_accessor :username, :api_key

  def initialize (username)
    @username = username
    @apikey = "4994d6ee-9566-4190-8b38-232ff7709ba9"
  end

  def authenticate (password)
    return false unless admin?
    RestClient.post(URI::escape("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/#{@username}/authenticate?apikey=#{@apikey}"), { 
      :password => password
    }) do |req, res, status|
      true if status.code == "200" # API return 200 on success only
    end
  end

  private
    def admin?
      true
    end
end