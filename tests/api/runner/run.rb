require 'pp'
require 'pry'

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

class RequestDumper
  def initialize(verb:, uri:, headers:, body:)
    @verb = verb
    @uri = uri
    @headers = headers
    @body = body
  end

  def to_s
    [
      "#{verb} #{uri}",
      headers.map {|k,v| "#{k}: #{v}"},
      "",
      body
    ].flatten.join("\n")
  end

  private

  attr_reader :verb, :uri, :headers, :body
end

# parser = RequestParser.new('./steps/03_create_player')
# dumper = RequestDumper.new(parser.to_h)
# File.open('./output', 'wb') { |f| f.write(dumper.to_s) }

# if File.read('./steps/03_create_player') != dumper.to_s
#   raise "Files are different, run diff on them!"
# end
