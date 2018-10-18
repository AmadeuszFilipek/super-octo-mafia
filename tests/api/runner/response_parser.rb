require './base_parser.rb'

class ResponseParser < BaseParser
  def http_version
    first_line_parts[0]
  end

  def status_code
    first_line_parts[1].to_i
  end

  def status_name
    first_line_parts[2]
  end

  def to_h
    super.merge(
      http_version: http_version,
      status_code: status_code,
      status_name: status_name,
    )
  end

  private

  def first_line_parts
    lines.first.scan(/(.*)\s+(\d+)\s+(.*)/).flatten
  end
end
