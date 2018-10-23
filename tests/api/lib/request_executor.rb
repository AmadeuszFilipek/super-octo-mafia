class RequestExecutor
  def initialize(request)
    @request = request
  end

  def call
    uri = "http://localhost:5000#{request[:uri]}"

    response = HTTP.send(request[:verb].downcase, uri)

    Response.new(
      response.status.to_i,
      response.reason,
      response.headers.to_h,
      response.body.to_s
    )
  end

  private

  attr_reader :request
end

