
class RequestDumper
  def initialize(request)
    @request = request
  end

  def to_s
    [
      "#{request.verb} #{request.uri}",
      request.headers.map {|k,v| "#{k}: #{v}"},
      "",
      request.body,
      ""
    ].flatten.join("\n")
  end

  private

  attr_reader :request
end

