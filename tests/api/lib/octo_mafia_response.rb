require 'json'

class OctoMafiaResponse < SimpleDelegator
  IGNORED_HEADERS = ['Date', 'Server', 'Content-Length']

  def body
    json = JSON.parse(super)
    json.delete('version')
    json['state']&.delete('started_at')
    JSON.dump(json)
  rescue JSON::ParserError
    super
  end

  def headers
    super.delete_if{ |k,v| IGNORED_HEADERS.include?(k) }
  end
end
