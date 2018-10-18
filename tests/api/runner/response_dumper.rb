
class ResponseDumper
  def self.from_http_response(response, ignore_headers: [])
    new(
      http_version: "HTTP/#{response.version}",
      status: response.status,
      headers: response.headers.to_h.delete_if{|k,v| ignore_headers.include?(k)},
      body: response.body.to_s
    )
  end

  def initialize(http_version:, status:, headers:, body:)
    @http_version = http_version
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
