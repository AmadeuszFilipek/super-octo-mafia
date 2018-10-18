
class ResponseDumper
  def self.from_http_response(response, ignore_headers: [], transform_body: nil)
    body = response.body.to_s
    body = transform_body.call(body) if transform_body

    new(
      http_version: "HTTP/#{response.version}",
      status: response.status,
      headers: response.headers.to_h.delete_if{|k,v| ignore_headers.include?(k)},
      body: body
    )
  end

  def initialize(http_version:, status:, headers:, body:)

    @status = status
    @headers = headers
    @body = body
  end

  def to_s
    [
      "#{http_version} #{status}",
      headers.map {|k,v| "#{k}: #{v}"},
      "",
      body,
      ""
    ].flatten.join("\n")
  end

  private

  attr_reader :http_version, :status, :headers, :body
end
