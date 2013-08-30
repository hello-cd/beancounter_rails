# encoding: utf-8
class Activity::Share < Activity

  def initialize(json)
    super(json)
    send("url=", json["object"]["url"])
    send("name=", json["object"]["name"])
  end
end

