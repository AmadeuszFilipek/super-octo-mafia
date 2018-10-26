
Request = Struct.new(:verb, :uri, :headers, :body) do
  def self.from_rack_env(env)
    verb = env['REQUEST_METHOD']
    path = env['REQUEST_PATH']

    headers = env.select{|(k,v)| k =~ /^HTTP_/}.map do |key, value|
      new_key = key.split('_')[1..-1].map do |part|
        part.downcase!; part[0] = part[0].upcase; part
      end.join('-')

      [new_key, value]
    end.to_h

    body = env['rack.input'].read

    new(verb, path, headers, body)
  end
end
