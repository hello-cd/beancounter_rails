class BeancounterUtils
  require "module/beancounter_rest_client"
  extend BeancounterRestClient

  def self.check_status
    begin
      get "#{base_url}api/check", &check_status_block
    rescue
      return false
    end
  end

  def self.version
    get "#{base_url}api/version", &version_block
  end

  def self.generate_api_key
    params = {
      :name => 'beancounter_demo',
      :description => 'beancounter demo application',
      :email => 'test@test.io',
      :oauthCallback => 'http://localhost:3000'
    }
    post "#{base_url}application/register", params, &generate_api_key_block
  end


  private

  def self.check_status_block
    Proc.new do |json, result|
      result.code == "200" && json["status"] == "OK"
    end
  end

  def self.version_block
    Proc.new do |json, result|
      if result.code == "200" && json["status"] == "OK"
        json["object"]
      end
    end
  end

  def self.generate_api_key_block
    Proc.new do |json, result|
      if result.code == "200"
        api_key = json["object"]
        Customer.new(:api_name => "bc", :api_value => api_key).save
      else
        false
      end
    end
  end

end
