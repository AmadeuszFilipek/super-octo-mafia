
require 'rack'
require 'pry'
require_relative 'lib/request'
require_relative 'lib/request_recorder'

request_recorder = RequestRecorder.new('./new_requests')

app = Proc.new do |env|
  incoming_request = Request.from_rack_env(env)
  request_recorder.record(incoming_request)

  # api_response = RequestExecutor.new(request).call

  ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
end

Rack::Handler::WEBrick.run app
