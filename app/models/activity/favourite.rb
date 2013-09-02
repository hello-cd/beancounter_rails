# encoding: utf-8
class Activity::Favourite < Activity

  def initialize(json)
    super(json)
    begin
      send("url=", json.fetch("object").fetch("link"))
    rescue Exception => e
      Rails.logger.error e.message
    end
  end
end

