
class ResponseDumper
  # def self.from_http_response(response, ignore_headers: [], transform_body: nil)
  #   body = response.body.to_s
  #   body = transform_body.call(body) if transform_body

  #   new(
  #     http_version: "HTTP/#{response.version}",
  #     status: response.status,
  #     headers: response.headers.to_h.delete_if{|k,v| ignore_headers.include?(k)},
  #     body: body
  #   )
  # end

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
