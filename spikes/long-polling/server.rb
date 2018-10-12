require 'bundler'
Bundler.require
require 'benchmark'

require 'pstore'
require 'yaml/store'
helpers do
  def yaml_store
    @yaml_store ||=
      YAML::Store.new('yaml.store', true).tap do |store|
        store.ultra_safe = true
      end
  end

  def pstore
    @pstore ||=
      YAML::Store.new('pstore.store.', true).tap do |store|
        store.ultra_safe = true
      end
  end

  def store
    yaml_store
  end
end

use Rack::Logger

get '/' do
  File.read File.expand_path('index.html')
end

get '/state' do
  sleep 0.3

  store.transaction do
    state = store.fetch(:state, {})
    request.logger.info state
    state
  end.merge(server_time: Time.now.to_i).to_json
end

post '/state' do
  request.body.rewind
  json = JSON.parse(request.body.read)

  store.transaction do
    store[:state] = json
  end.to_json
end
