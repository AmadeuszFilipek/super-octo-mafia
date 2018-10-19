class RequestExecutor
  def initialize(request)
    @request = request
  end

  def call
    uri = "http://localhost:5000#{request[:uri]}"

    HTTP.send(request[:verb].downcase, uri)
  end

  private

  attr_reader :request
end

