# encoding: utf-8
class Activity::Like < Activity

  def initialize(json)
    super(json)
    send("url=", json["object"]["url"])
    send("name=", json["object"]["name"])
    send("categories=", json["object"]["categories"])
  end
end

