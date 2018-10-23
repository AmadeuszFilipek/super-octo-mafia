require './spec_helper'
require './response_parser'

describe ResponseParser do
  let(:parser) { ResponseParser.new(File.read('./fixtures/' + fixture)) }
  let(:response) { parser.parse }

  context "response file containing all data" do
    let(:fixture) { 'full.response' }

    specify do
      expect(response.status).to eq 200
      expect(response.headers).to eq(
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two'
      )
      expect(response.body).to eq 'some body'
    end
  end

  context "response file lacking headers" do
    let(:fixture) { 'without_headers.response' }

    specify do
      expect(response.status).to eq 200
      expect(response.headers).to eq({})
      expect(response.body).to eq 'some body'
    end
  end

  context "response file lacking body" do
    let(:fixture) { 'without_body.response' }

    specify do
      expect(response.status).to eq 200
      expect(response.headers).to eq(
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two'
      )
      expect(response.body).to eq ''
    end
  end

  context "response file lacking body and headers" do
    let(:fixture) { 'only_status.response' }

    specify do
      expect(response.status).to eq 200
      expect(response.headers).to eq({})
      expect(response.body).to eq ''
    end
  end
end
