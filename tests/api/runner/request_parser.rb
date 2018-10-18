require './base_parser.rb'

class RequestParser < BaseParser
  def verb
    first_line.split(/\s+/).first
  end

  def uri
    first_line.split(/\s+/).last
  end
end
