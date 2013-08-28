class Admin

	attr_accessor :username

	def initialize ( username )
		@username = username
	end

	def authenticate ( password )
    RestClient.post(URI::escape("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/#{@username}/authenticate?apikey=#{get_apikey}"), { 
    	:password => password
    }) do |req, res, status| 
    	true if status.code == "200" # API RETURNS 200 ON SUCCESS ONLY
    end
	end

	private
		def get_apikey
			return "4994d6ee-9566-4190-8b38-232ff7709ba9" # hardcoded apikey
		end

		def is_admin?
			true # always true for now
		end
end