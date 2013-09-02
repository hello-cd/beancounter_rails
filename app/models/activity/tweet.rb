# encoding: utf-8
class Activity::Tweet < Activity

  def initialize(json)
    super(json)
    begin
      send("url=", json.fetch("object").fetch("urls"))
      send("name=", json.fetch("object").fetch("text"))
    rescue Exception => e
      Rails.logger.error e.message
    end
  end
end

