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

  def json_users
    RestClient.get("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/all?apikey=#{application_setting.api_value}") do |req, res, status|
      json_response = JSON.parse(req.body)
      if status.code == "200" && json_response["status"] == "OK"
        json_response["object"]
      else
        []
      end
    end
  end

  def users
    users = []
    json_users.each do |json_user|
      user = User.new(:username => json_user["username"], :email => json_user["email"])
      user.full_name = json_user["metadata"]["twitter.user.name"] || (json_user["metadata"]["facebook.user.firstname"] +
                                                                " " + json_user["metadata"]["facebook.user.lastname"])
      user.picture   = json_user["metadata"]["twitter.user.imageUrl"] || json_user["metadata"]["facebook.user.picture"]
      user.provider  = if json_user["services"].include?("facebook")
                         "facebook"
                       else
                         "twitter"
                       end
      users << user
    end
    users
  end

  private
    def admin?
      true
    end
end
