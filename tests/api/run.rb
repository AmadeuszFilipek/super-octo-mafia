require 'pp'
require 'pry'

class RequestParser
  def initialize(path)
    @path = path
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
    parts.last[1..-1].join
  end

  def to_h
    { verb: verb, uri: uri, headers: headers, body: body }
  end

  private

  attr_reader :path

  def parts
    lines.slice_before(/\A\s+\z/).to_a
  end

  def lines
    @lines ||= File.readlines(path)
  end

  def first_line
    lines.first
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

parser = RequestParser.new('./steps/03_create_player')
dumper = RequestDumper.new(parser.to_h)
File.open('./output', 'wb') { |f| f.write(dumper.to_s) }

if File.read('./steps/03_create_player') != dumper.to_s
  raise "Files are different, run diff on them!"
end
