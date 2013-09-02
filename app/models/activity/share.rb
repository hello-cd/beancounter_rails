# encoding: utf-8
class Activity::Share < Activity

  def initialize(json)
    super(json)
    begin
      send("url=", [json.fetch("object").fetch("url")])
      send("name=", json.fetch("object").fetch("name"))
    rescue Exception => e
      Rails.logger.error e.message
    end
  end
end

