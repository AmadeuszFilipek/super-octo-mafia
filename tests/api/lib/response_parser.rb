require_relative './base_parser.rb'

class ResponseParser < BaseParser
  def http_version
    first_line_parts[0]
  end

  def status
    first_line_parts[1].to_i
  end

  def to_h
    super.merge(
      http_version: http_version,
      status: status,
    )
  end

  private

  def first_line_parts
    lines.first.scan(/(.*)\s+(\d+)\s+(.*)/).flatten
  end
end
