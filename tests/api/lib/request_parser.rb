require_relative 'request'
require_relative 'base_parser'

class RequestParser < BaseParser
  def verb
    first_line.split(/\s+/).first
  end

  def uri
    first_line.split(/\s+/).last
  end

  def parse
    Request.new(verb, uri, headers, body)
  end
end
