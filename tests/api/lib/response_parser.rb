require_relative 'base_parser'
require_relative 'response'

class ResponseParser < BaseParser
  def http_version
    first_line_parts[0]
  end

  def status
    first_line_parts[1].to_i
  end

  def status_name
    first_line_parts[2]
  end

  def to_h
    super.merge(
      http_version: http_version,
      status: status,
    )
  end

  def parse
    Response.new(status, status_name, headers, body)
  end

  private

  def first_line_parts
    lines.first.scan(/(.*)\s+(\d+)\s+(.*)/).flatten
  end
end
