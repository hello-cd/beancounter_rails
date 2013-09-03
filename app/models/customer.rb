class Customer < ActiveRecord::Base
  attr_accessible :api_name, :api_value, :super

  require "uri"
  require "net/http"
  require "module/beancounter_rest_client"
  include BeancounterRestClient

  def users
    users = []
    json_users.each do |json_user|
      user = User.new(:username => json_user["username"], :email => json_user["email"])
      user.fields_from_json(json_user)
      user.load_profile(api_value)
      users << user
    end
    users
  end

  private

  def json_users
    get "#{base_url}user/all?apikey=#{api_value}", &json_users_block
  end

  def json_users_block
    Proc.new do |json, result|
      if result.code == "200" && json["status"] == "OK"
        json["object"]
      else
        []
      end
    end
  end
end
