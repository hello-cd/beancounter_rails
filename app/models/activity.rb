# encoding: utf-8
class Activity
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity
  require "module/beancounter_rest_client"
  extend BeancounterRestClient

  attr_accessor :timestamp, :verb, :url, :name, :categories
  attr_accessible :timestamp, :verb, :url, :name, :categories

  def initialize(json)
    begin
      send("categories=", [])
      send("verb=", json.fetch("verb"))
      send("timestamp=", json.fetch("context")["date"])
    rescue Exception => e
      Rails.logger.error e.message
    end
  end

  def date
    Time.at(timestamp / 1000.0) if timestamp
  end

  def self.find_by_id(activity_id, apikey)
    get "#{base_url}activities/#{activity_id}?apikey=#{apikey}", &find_activity
  end

  private

  def self.find_activity
    Proc.new do |json, result|
      if result.code == "200" && json["status"] == "OK"
        json_activity = json['object']['activity']
        Kernel.const_get("Activity").const_get(json_activity["verb"].titleize).new(json_activity)
      else
        []
      end
    end
  end

end
