class Admin < ActiveRecord::Base
  require "module/beancounter_rest_client"
  include BeancounterRestClient

  attr_accessible :username
  belongs_to :customer
  delegate :super?, :to => :customer

  def authenticate (password)
    return false unless admin?
    post "#{base_url}user/#{username}/authenticate?apikey=#{customer.api_value}", { :password => password }, &authenticate_block
  end


  private
    def admin?
      true
    end

    def authenticate_block
      Proc.new do |json, result|
        result.code == "200"
      end
    end
end
