
class ResponseDumper
  def initialize(response)
    @response = response
  end

  def to_s
    [
      "HTTP/1.0 #{response.status} #{response.status_name}",
      response.headers.map {|k,v| "#{k}: #{v}"},
      "",
      response.body,
      ""
    ].flatten.join("\n")
  end

  private

  attr_reader :response
end
