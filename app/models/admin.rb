class Admin < ActiveRecord::Base
  attr_accessible :username
  belongs_to :application_setting

  def authenticate (password)
    return false unless admin?
    RestClient.post(URI::escape("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/#{username}/authenticate?apikey=#{application_setting.api_value}"), {
      :password => password
    }) do |req, res, status|
      true if status.code == "200" # API return 200 on success only
    end
  end

  def users
    RestClient.get("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/all?apikey=#{application_setting.api_value}") do |req, res, status|
      json_response = JSON.parse(res.body)
      if status.code == "200" && json_response["status"] == "OK"
        return json_response["object"]
      end
    end
  end

  private
    def admin?
      true
    end
end
