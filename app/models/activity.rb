# encoding: utf-8
class Activity
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :timestamp, :verb, :url, :name, :categories
  attr_accessible :timestamp, :verb, :url, :name, :categories

  def initialize(json)
    send("verb=", json["verb"])
    send("timestamp=", json["context"]["date"])
  end

  def date
    Time.at(timestamp / 1000.0) if timestamp
  end

end
