require_relative 'request'
require_relative 'http_message_parser'

class RequestParser < HTTPMessageParser
  def verb
    request_line.split(/\s+/).first
  end

  def uri
    request_line.split(/\s+/).last
  end

  def parse
    Request.new(verb, uri, headers, body)
  end
end
