module BeancounterRestClient
  def get(*args, &response_builder)
    RestClient.get(*args, &default_block(&response_builder))
  end

  def post(*args, &response_builder)
    RestClient.post(*args, &default_block(&response_builder))
  end

  def base_url
    "http://#{BC_PLATFORM_HOST}:#{BC_PLATFORM_PORT}/beancounter-platform/rest/"
  end

  def default_block &response_builder
    Proc.new do |response, request, result|
      json_response = JSON.parse(response.body)
      response_builder.call(json_response, result)
    end
  end
end
