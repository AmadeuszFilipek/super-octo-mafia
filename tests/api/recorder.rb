
require 'rack'
require 'pry'
require_relative 'lib/request'
require_relative 'lib/request_dumper'

@request_index = 0
FileUtils.mkdir_p('./new_requests')

app = Proc.new do |env|
  @request_index+= 1

  incoming_request = Request.from_rack_env(env)
  request_dumper = RequestDumper.new(incoming_request)
  incoming_request_name = sprintf("%03d", @request_index)
  incoming_request_path = "./new_requests/#{incoming_request_name}.request"
  File.open(incoming_request_path, 'wb') { |f| f.write(request_dumper.to_s) }

  # api_response = RequestExecutor.new(request).call

  ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
end

Rack::Handler::WEBrick.run app
