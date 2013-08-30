# encoding: utf-8
class Activity::Tweet < Activity

  def initialize(json)
    super(json)
    send("url=", json["object"]["urls"])
    send("name=", json["object"]["text"])
  end
end

