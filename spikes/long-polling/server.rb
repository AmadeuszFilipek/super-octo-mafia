require 'bundler'
Bundler.require

use Rack::Logger

get '/' do
  send_file File.expand_path('index.html')
end

get '/poll' do
  request.logger.info "sleep STTART"
  sleep 5
  request.logger.info 'sleep END'
  'true'
end
