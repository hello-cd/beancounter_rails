class Customer < ActiveRecord::Base
  attr_accessible :api_name, :api_value, :super

  require "uri"
  require "net/http"

  def self.generate_beancounter_api_key
    RestClient.post("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/application/register",{
      :name => 'beancounter_demo',
      :description => 'beancounter demo application',
      :email => 'test@test.io',
      :oauthCallback => 'http://localhost:3000'
    }) do | req, res, result|
      if result.code == "200"
        api_key = JSON.parse(req.body)["object"]
        Customer.new(:api_name => "bc", :api_value => api_key).save
      else
        false
      end
    end
  end

  def json_users
    RestClient.get("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/all?apikey=#{api_value}") do |req, res, status|
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

  def self.api_key
    if Customer.all.empty?
      generate_beancounter_api_key
    end
    Customer.first.api_value
  end

  def self.check_status
    begin
      RestClient.get("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/api/check") do |req, res, result|
        result.code == "200" && JSON.parse(req.body)["status"] == "OK"
      end
    rescue
      return false
    end
  end

  def self.version
    RestClient.get("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/api/version") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        JSON.parse(req.body)["object"]
      end
    end
  end
end
