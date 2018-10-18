require 'pry'
require 'http'
require './runner/request_dumper.rb'
require './runner/request_parser.rb'
require './runner/response_dumper.rb'
require './runner/response_parser.rb'

class RequestExecutor
  def initialize(request)
    @request = request
  end

  def call
    uri = "http://localhost:5000#{request[:uri]}"
    puts "#{request[:verb]} #{uri}"

    HTTP.send(request[:verb].downcase, uri)
  end

  private

  attr_reader :request
end

HEADERS_TO_IGNORE = ['Date', 'Server', 'Content-Length']

Dir['./steps/*'].sort.take(1).each do |step|
  cached_response_path = "./responses_v2/#{File.basename(step)}"
  cached_response_string = if File.exists?(cached_response_path)
                             File.read(cached_response_path)
                           else
                             ''
                           end

  request = RequestParser.new(File.read(step)).to_h
  response = RequestExecutor.new(request).call

  dumper = ResponseDumper.from_http_response(response, ignore_headers: HEADERS_TO_IGNORE)
  actual_response_string = dumper.to_s
  binding.pry

  `diff <(echo '#{cached_response_string}') <(echo '#{actual_response_string}')`
end
