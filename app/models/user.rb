# encoding: utf-8
class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity
  require "module/beancounter_rest_client"
  include BeancounterRestClient

  attr_accessor :username,:token, :name, :providers, :picture, :full_name, :email, :interests, :categories
  attr_accessible :username,:token, :name, :providers, :picture, :full_name, :email, :interests, :categories

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    self.interests  = []
    self.categories = []
    self.providers  = []
  end

  def fields_from_json(json_user)
    metadata = json_user["metadata"]
    self.full_name = metadata["twitter.user.name"] || facebook_full_name(metadata)
    self.picture   = metadata["twitter.user.imageUrl"] || metadata["facebook.user.picture"]
    self.providers << "facebook" if json_user["services"].include?("facebook")
    self.providers << "twitter"  if json_user["services"].include?("twitter")
  end

  def persisted?
    false
  end

  def public_page(service, message)
    true
  end

  def facebook_full_name(metadata)
    "#{metadata["facebook.user.firstname"]} #{metadata["facebook.user.lastname"]}"
  end

  def get_profile
    get "#{base_url}user/#{username}/profile/me?token=#{token}", &get_profile_block
  end

  def load_profile(apikey)
    get "#{base_url}user/#{username}/profile?apikey=#{apikey}", &profile_block
  end

  def get_user_data
    get "#{base_url}user/#{username}/me?token=#{token}", &get_user_data_block
  end

  def json_activities(admin)
    get "#{base_url}activities/search?path=activity.username&value=#{username}&apikey=#{admin.customer.api_value}", &json_activities_block
  end

  def activities(admin)
    activities = []
    json_activities(admin).each do |json|
      json_activity = json["activity"]
      activity = Kernel.const_get("Activity").const_get(json_activity["verb"].titleize).new(json_activity)
      activities << activity
    end
    activities
  end

  def provider?(provider)
    return false if self.providers.nil?
    self.providers.include?(provider)
  end

  private

  def json_activities_block
    Proc.new do |json, result|
      if result.code == "200" && json["status"] == "OK"
        json['object']
      else
        []
      end
    end
  end

  def get_user_data_block
    Proc.new do |json, result|
      if result.code == "200" && json["status"] == "OK"
        user_information = json['object']
        if ["twitter", "facebook"] - user_information['services'].keys == []
          self.name = "#{user_information['metadata']['twitter.user.name']}"
          if self.name.empty?
            self.name = "#{user_information['metadata']['facebook.user.firstname']} #{user_information['metadata']['facebook.user.lastname']}"
          end
          self.providers = ["facebook", "twitter"]
        elsif user_information['services'].keys == ["facebook"]
          self.name = "#{user_information['metadata']['facebook.user.firstname']} #{user_information['metadata']['facebook.user.lastname']}"
          self.providers = ["facebook"]
        elsif user_information['services'].keys == ["twitter"]
          self.name = "#{user_information['metadata']['twitter.user.name']}"
          self.providers = ["twitter"]
        end
      else
        false
      end
    end
  end

  def get_profile_block
    Proc.new do |json, result|
      if result.code == "200" && json["status"] == "OK"
        [ json['object']['interests'], json['object']['categories'] ]
      end
    end
  end

  def profile_block
    Proc.new do |json, result|
      if result.code == "200" && json["status"] == "OK"
        json['object']['interests'].each do |json_interest|
          self.interests << Interest.new(json_interest)
        end

        json['object']['categories'].each do |json_category|
          self.categories << Category.new(json_category)
        end
      end
    end
  end

end
