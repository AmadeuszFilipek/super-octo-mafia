require './spec_helper.rb'
require './response_dumper.rb'
require 'http'

describe ResponseDumper do
  describe '.from_http_response' do
    it 'initializes dumper' do
      expect(ResponseDumper).to receive(:new).with(
        http_version: "HTTP/1.1",
        status: 304,
        headers: {
          'Header-One' => 'Value One',
          'Header-Two' => 'Value Two',
        },
        body: 'some body'
      )

      response = double(HTTP::Response,
        version: '1.1',
        status: 304,
        headers: double(HTTP::Headers,
                        to_h: {
                          'Header-One' => 'Value One',
                          'Header-Two' => 'Value Two',
                        }),
        body: double(HTTP::Response::Body, to_s: 'some body')
      )

      ResponseDumper.from_http_response(response)
    end
  end
end
