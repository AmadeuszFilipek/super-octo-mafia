
class OctoMafiaResponse < SimpleDelegator
  IGNORED_HEADERS = ['Date', 'Server', 'Content-Length']

  def body
    json = JSON.parse(super)

    if json.key?('version')
      json['version'] = nil
    end

    if json.key?('state') && json['state'].key?('started_at')
      json['state']['started_at'] = nil
    end

    JSON.dump(json)
  rescue JSON::ParserError
    super
  end

  def headers
    super.delete_if{ |k,v| IGNORED_HEADERS.include?(k) }
  end
end
