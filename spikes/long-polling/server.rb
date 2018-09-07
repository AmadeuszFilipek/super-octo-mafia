require 'bundler'
Bundler.require

use Rack::Logger

get '/' do
  send_file File.expand_path('index.html')
end

get '/poll' do
  request.logger.info "sleep STTART"
  sleep 1
  request.logger.info 'sleep END'

  DateTime.now.iso8601.to_json
end
