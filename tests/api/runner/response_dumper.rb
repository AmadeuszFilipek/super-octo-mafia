
class ResponseDumper
  def initialize(http_version:, status_code:, status_name:, headers:, body:)
    @http_version = http_version
    @status_name = status_name
    @status_code = status_code
    @headers = headers
    @body = body
  end

  def to_s
    [
      "#{http_version} #{status_code} #{status_name}",
      headers.map {|k,v| "#{k}: #{v}"},
      "",
      body,
      ""
    ].flatten.join("\n")
  end

  private

  attr_reader :http_version, :status_code, :status_name, :headers, :body
end
