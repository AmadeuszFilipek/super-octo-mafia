require_relative 'request'
require_relative 'base_parser'

class RequestParser < BaseParser
  def verb
    first_line.split(/\s+/).first
  end

  def uri
    first_line.split(/\s+/).last
  end

  def to_h
    super.merge(
      verb: verb,
      uri: uri,
    )
  end

  def parse
    Request.new(verb, uri, headers, body)
  end
end
