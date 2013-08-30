# encoding: utf-8
class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :username,:token, :name, :provider, :picture, :full_name, :email
  attr_accessible :username,:token, :name, :provider, :picture, :full_name, :email

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def get_profile
    RestClient.get("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/#{username}/profile?token=#{token}") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        return JSON.parse(req.body)['object']['interests'], JSON.parse(req.body)['object']['categories']
      end
    end
  end

  def get_user_data
    RestClient.get("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/user/#{username}/me?token=#{token}") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        user_information = JSON.parse(req.body)['object']
        if ["twitter", "facebook"] - user_information['services'].keys == []
          self.name = "#{user_information['metadata']['twitter.user.name']}"
          if self.name.empty?
            self.name = "#{user_information['metadata']['facebook.user.firstname']} #{user_information['metadata']['facebook.user.lastname']}"
          end
          self.provider = :both
        elsif user_information['services'].keys == ["facebook"]
          self.name = "#{user_information['metadata']['facebook.user.firstname']} #{user_information['metadata']['facebook.user.lastname']}"
          self.provider = :facebook
        elsif user_information['services'].keys == ["twitter"]
          self.name = "#{user_information['metadata']['twitter.user.name']}"
          self.provider = :twitter
        end
      else
        false
      end
    end
  end

  def json_activities(admin)
    RestClient.get("http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/activities/search?path=activity.username&value=#{username}&apikey=#{admin.application_setting.api_value}") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        JSON.parse(req.body)['object']
      else
        []
      end
    end
  end

  def activities(admin)
    activities = []
    json_activities(admin).each do |json|
      json_activity = json["activity"]
      activity = Activity.new(:timestamp => json_activity["context"]["date"], :verb => json_activity["verb"])
      activity.url = json_activity["object"]["urls"] || json_activity["object"]["link"] || json_activity["object"]["url"]
      activity.name = json_activity["object"]["name"] || json_activity["object"]["text"]
      activity.categories = json_activity["object"]["categories"]
      activities << activity
    end
    activities
  end

  def provider?(provider)
    return true if self.provider == :both
    if self.provider == provider
      return true
    else
      return false
    end
  end

  def public_page(service, message)
    true
  end
end
