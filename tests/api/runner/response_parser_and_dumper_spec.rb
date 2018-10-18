require './spec_helper.rb'
require './response_parser.rb'
require './response_dumper.rb'

describe ResponseParser do
  specify do
    attributes =  {
      http_version: 'HTTP/1.0',
      status_code: 304,
      status_name: 'Moved Permanently',
      headers: {
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two',
      },
      body: 'some body',
    }

    content = ResponseDumper.new(attributes).to_s
    parser = ResponseParser.new(content)

    expect(parser.to_h).to eq attributes
  end
end
