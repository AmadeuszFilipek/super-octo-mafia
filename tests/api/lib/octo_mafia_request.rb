
class OctoMafiaRequest < SimpleDelegator
  ALLOWED_HEADERS = ['Content-Type']

  def headers
    super.delete_if{ |k,v| !ALLOWED_HEADERS.include?(k) }
  end

  def irrelevant?
    uri == '/favicon.ico'
  end
end
