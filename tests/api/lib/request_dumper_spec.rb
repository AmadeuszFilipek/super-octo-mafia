require_relative 'spec_helper'
require_relative 'response_dumper'
require_relative 'response'

describe ResponseDumper do
  let(:response) { Response.new(status, status_name, headers, body) }
  let(:dumper) { ResponseDumper.new(response) }
  let(:content) { dumper.to_s.strip }

  def fixture_for(name)
    File.read('./fixtures/' + name).strip
  end

  context "with all data" do
    let(:status) { 200 }
    let(:status_name) { 'OK' }
    let(:headers) do
      {
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two'
      }
    end
    let(:body) { 'some body' }

    specify do
      expect(content).to eq fixture_for('full.response')
    end
  end

  context "lacking headers" do
    let(:status) { 200 }
    let(:status_name) { 'OK' }
    let(:headers) { Hash.new }
    let(:body) { 'some body' }

    specify do
      expect(content).to eq fixture_for('without_headers.response')
    end
  end

  context "lacking body" do
    let(:status) { 200 }
    let(:status_name) { 'OK' }
    let(:headers) do
      {
        'Header-One' => 'Value One',
        'Header-Two' => 'Value Two'
      }
    end
    let(:body) { '' }

    specify do
      expect(content).to eq fixture_for('without_body.response')
    end
  end

  context "lacking body and headers" do
    let(:status) { 200 }
    let(:status_name) { 'OK' }
    let(:headers) { Hash.new }
    let(:body) { '' }

    specify do
      expect(content).to eq fixture_for('only_status.response')
    end
  end
end
