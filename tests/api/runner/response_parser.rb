
class ResponseParser < RequestParser
  def http_version
    first_line_parts[0]
  end

  def status_code
    first_line_parts[1].to_i
  end

  def status_name
    first_line_parts[2]
  end

  private

  def first_line_parts
    lines.first.scan(/(.*)\s+(\d+)\s+(.*)/).flatten
  end
end
