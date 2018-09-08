require 'bundler'
Bundler.require

require 'yaml/store'
class Store < DelegateClass(YAML::Store)
  class << self
    attr_accessor :pstore, :mutex
  end

  def initialize(path)
    self.class.pstore ||= PStore.new(path)
    self.class.mutex ||= Mutex.new

    super self.class.pstore
  end

  def transaction(&block)
    self.class.mutex.synchronize { super(&block) }
  end
end

helpers do
  def store
    Store.new('test.store')
  end
end

use Rack::Logger

get '/' do
  send_file File.expand_path('index.html')
end

get '/poll' do
  sleep 1

  store.transaction do
    request.logger.info store[:state]
    store[:state]
  end.to_json
end

post '/state' do
  # sleep 5

  request.body.rewind
  json = JSON.parse(request.body.read)

  store.transaction do
    store[:state] = json
  end.to_json
end
