# encoding: utf-8
class Activity
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :timestamp, :verb, :url, :name, :categories
  attr_accessible :timestamp, :verb, :url, :name, :categories

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def date
    Time.at(timestamp / 1000.0)
  end

end
