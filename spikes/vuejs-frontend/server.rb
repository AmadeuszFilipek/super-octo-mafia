require 'bundler'
Bundler.require

STATE_IDS = %w(waiting_for_players day_voting day_results night_voting night_results end_game)

get '/state' do
  {
    state: {
      id: STATE_IDS.sample,
      server_time: Time.now.to_i
    }
  }.to_json
end

get '/' do
  send_file 'index.html'
end

get '/vue.js' do
  send_file 'vue.js'
end

get '/app.js' do
  send_file 'app.js'
end

