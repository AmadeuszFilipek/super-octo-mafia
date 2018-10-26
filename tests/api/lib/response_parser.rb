require_relative 'response'
require_relative 'http_message_parser'

class ResponseParser < HTTPMessageParser
  def http_version
    first_line_parts[0]
  end

  def status
    first_line_parts[1].to_i
  end

  def status_name
    first_line_parts[2]
  end

  def parse
    Response.new(status, status_name, headers, body)
  end

  private

  def first_line_parts
    lines.first.scan(/(.*)\s+(\d+)\s+(.*)/).flatten
  end
end
