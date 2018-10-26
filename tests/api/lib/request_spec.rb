require_relative 'spec_helper'
require_relative 'request'

describe Request do
  describe ".from_rack_env" do
    specify do
      env = {
        'REQUEST_METHOD' => 'POST',
        'REQUEST_PATH' => '/some/api/path',
        'HTTP_HEADER_ONE' => 'Value One',
        'HTTP_HEADER_TWO' => 'Value Two',
        'NON_HEADER_STUFF' => 'Some value',
        'rack.input' => StringIO.new('some body'),
      }

      request = Request.from_rack_env(env)

      expect(request.verb).to eq 'POST'
      expect(request.uri).to eq '/some/api/path'
      expect(request.headers).to eq(
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two',
      )
    end
  end
end
