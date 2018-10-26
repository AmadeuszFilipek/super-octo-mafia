
require 'rack'
require 'pry'
require_relative 'lib/request'
require_relative 'lib/request_recorder'
require_relative 'lib/octo_mafia_request'

request_recorder = RequestRecorder.new('./new_requests')

app = Proc.new do |env|
  incoming_request = Request.from_rack_env(env)
  octo_mafia_request = OctoMafiaRequest.new(incoming_request)

  if octo_mafia_request.recordable?
    request_recorder.record(octo_mafia_request)
  end

  # api_response = RequestExecutor.new(request).call

  ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
end

Rack::Handler::WEBrick.run app
