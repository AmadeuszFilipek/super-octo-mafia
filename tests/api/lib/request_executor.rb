require 'http'

class RequestExecutor
  def initialize(request)
    @request = request
  end

  def call
    uri = "http://localhost:5000#{request[:uri]}"

    http_response = HTTP.send(
      request[:verb].downcase,
      uri,
      headers: request.headers,
      body: request.body
    )

    Response.new(
      http_response.status.to_i,
      http_response.reason,
      http_response.headers.to_h,
      http_response.body.to_s
    )
  end

  private

  attr_reader :request
end

