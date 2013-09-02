class Admin < ActiveRecord::Base
  attr_accessible :username
  belongs_to :customer

  def api_name
    application_setting.api_name
  end

  def authenticate (password)
    return false unless admin?
    RestClient.post(URI::escape("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/#{username}/authenticate?apikey=#{customer.api_value}"), {
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
