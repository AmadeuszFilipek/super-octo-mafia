require_relative 'spec_helper'
require_relative 'request_parser'

describe RequestParser do
  let(:parser) { RequestParser.new(File.read('./fixtures/' + fixture)) }
  let(:request) { parser.parse }

  context "request file containing all data" do
    let(:fixture) { 'full.request' }

    specify do
      expect(request.verb).to eq 'DELETE'
      expect(request.uri).to eq '/some/api/path'
      expect(request.headers).to eq(
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two'
      )
      expect(request.body).to eq 'some body'
    end
  end

  context "request file lacking headers" do
    let(:fixture) { 'without_headers.request' }

    specify do
      expect(request.verb).to eq 'DELETE'
      expect(request.uri).to eq '/some/api/path'
      expect(request.headers).to eq({})
      expect(request.body).to eq 'some body'
    end
  end

  context "request file lacking body" do
    let(:fixture) { 'without_body.request' }

    specify do
      expect(request.verb).to eq 'DELETE'
      expect(request.uri).to eq '/some/api/path'
      expect(request.headers).to eq(
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two'
      )
      expect(request.body).to eq ''
    end
  end

  context "request file lacking body and headers" do
    let(:fixture) { 'only_verb_and_uri.request' }

    specify do
      expect(request.verb).to eq 'DELETE'
      expect(request.uri).to eq '/some/api/path'
      expect(request.headers).to eq({})
      expect(request.body).to eq ''
    end
  end
end
