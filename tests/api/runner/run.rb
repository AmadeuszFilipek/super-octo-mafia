require 'pp'
require 'pry'

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
