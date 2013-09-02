# encoding: utf-8
class Activity
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

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

end
