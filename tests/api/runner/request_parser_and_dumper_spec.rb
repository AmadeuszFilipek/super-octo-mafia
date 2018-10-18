require './spec_helper.rb'
require './request_parser.rb'
require './request_dumper.rb'

describe RequestParser do
  specify do
    attributes =  {
      verb: 'DELETE',
      uri: '/some/api/path',
      headers: {
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two',
      },
      body: 'some body',
    }

    content = RequestDumper.new(attributes).to_s
    parser = RequestParser.new(content)

    expect(parser.to_h).to eq attributes
  end
end
