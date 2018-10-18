
class RequestParser
  def initialize(content)
    @content = content
  end

  def verb
    lines.first.split(/\s+/).first
  end

  def uri
    lines.first.split(/\s+/).last
  end

  def headers
    parts.first[1..-1].map do |line|
      line.strip.split(/:\s+/)
    end.to_h
  end

  def body
    return '' if parts.length == 1

    parts[1][1..-1].join
  end

  def to_h
    { verb: verb, uri: uri, headers: headers, body: body }
  end

  private

  attr_reader :content

  def parts
    lines.slice_before(/\A\s*\z/).to_a
  end

  def lines
    @lines ||= content.split("\n")
  end

  def first_line
    lines[0]
  end
end
