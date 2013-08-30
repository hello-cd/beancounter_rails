# encoding: utf-8
class Activity::Favourite < Activity

  def initialize(json)
    super(json)
    send("url=", json["object"]["link"])
  end
end

