require_relative 'request_dumper'
require_relative 'request'

describe RequestDumper do
  let(:request) { Request.new(verb, uri, headers, body) }
  let(:dumper) { RequestDumper.new(request) }
  let(:content) { dumper.to_s.strip }

  def fixture_for(name)
    File.read('./fixtures/' + name).strip
  end

  context "with all data" do
    let(:verb) { 'DELETE' }
    let(:uri) { '/some/api/path' }
    let(:headers) do
      {
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two'
      }
    end
    let(:body) { 'some body' }

    specify do
      expect(content).to eq fixture_for('full.request')
    end
  end

  context "lacking headers" do
    let(:verb) { 'DELETE' }
    let(:uri) { '/some/api/path' }
    let(:headers) { Hash.new }
    let(:body) { 'some body' }

    specify do
      expect(content).to eq fixture_for('without_headers.request')
    end
  end

  context "lacking body" do
    let(:verb) { 'DELETE' }
    let(:uri) { '/some/api/path' }
    let(:headers) do
      {
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two'
      }
    end
    let(:body) { '' }

    specify do
      expect(content).to eq fixture_for('without_body.request')
    end
  end

  context "lacking body and headers" do
    let(:verb) { 'DELETE' }
    let(:uri) { '/some/api/path' }
    let(:headers) { Hash.new }
    let(:body) { '' }

    specify do
      expect(content).to eq fixture_for('only_verb_and_uri.request')
    end
  end
end
