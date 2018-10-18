
class RequestDumper
  def initialize(verb:, uri:, headers:, body:)
    @verb = verb
    @uri = uri
    @headers = headers
    @body = body
  end

  def to_s
    [
      "#{verb} #{uri}",
      headers.map {|k,v| "#{k}: #{v}"},
      "",
      body,
      ""
    ].flatten.join("\n")
  end

  private

  attr_reader :verb, :uri, :headers, :body
end

