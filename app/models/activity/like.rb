# encoding: utf-8
class Activity::Like < Activity

  def initialize(json)
    super(json)
    begin
      send("url=", [json.fetch("object").fetch("url")])
      send("name=", json.fetch("object").fetch("name"))
      send("categories=", json.fetch("object").fetch("categories"))
    rescue Exception => e
      Rails.logger.error e.message
    end
  end
end

