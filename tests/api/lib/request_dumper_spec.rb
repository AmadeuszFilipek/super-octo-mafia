require './spec_helper'
require './response_dumper'
require './response'
require 'http'

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

# describe ResponseDumper do
#   describe '.from_http_response' do
#     it 'initializes dumper' do
#       expect(ResponseDumper).to receive(:new).with(
#         http_version: "HTTP/1.1",
#         status: 304,
#         headers: {
#           'Header-One' => 'Value One',
#           'Header-Two' => 'Value Two',
#         },
#         body: 'some body'
#       )

#       response = double(HTTP::Response,
#         version: '1.1',
#         status: 304,
#         headers: double(HTTP::Headers,
#                         to_h: {
#                           'Header-One' => 'Value One',
#                           'Header-Two' => 'Value Two',
#                         }),
#         body: double(HTTP::Response::Body, to_s: 'some body')
#       )

#       ResponseDumper.from_http_response(response)
#     end

#     it 'uses ignore_headers if present' do
#       expect(ResponseDumper).to receive(:new).with(
#         http_version: "HTTP/1.1",
#         status: 304,
#         headers: {
#           'Header-One' => 'Value One',
#           'Header-Two' => 'Value Two',
#         },
#         body: 'some body'
#       )

#       response = double(HTTP::Response,
#         version: '1.1',
#         status: 304,
#         headers: double(HTTP::Headers,
#                         to_h: {
#                           'Header-One' => 'Value One',
#                           'Header-Two' => 'Value Two',
#                           'Date' => Date.today.to_s,
#                           'Server' => 'some server info',
#                         }),
#         body: double(HTTP::Response::Body, to_s: 'some body')
#       )

#       ResponseDumper.from_http_response(response, ignore_headers: ['Date', 'Server'])
#     end

#     it 'uses transform_body if present' do
#       expect(ResponseDumper).to receive(:new).with(
#         http_version: "HTTP/1.1",
#         status: 304,
#         headers: {
#           'Header-One' => 'Value One',
#           'Header-Two' => 'Value Two',
#         },
#         body: 'some bodysome bodysome body'
#       )

#       response = double(HTTP::Response,
#         version: '1.1',
#         status: 304,
#         headers: double(HTTP::Headers,
#                         to_h: {
#                           'Header-One' => 'Value One',
#                           'Header-Two' => 'Value Two',
#                         }),
#         body: double(HTTP::Response::Body, to_s: 'some body')
#       )

#       three_times_body = ->(body) {
#         [body, body, body].join
#       }
#       ResponseDumper.from_http_response(response, transform_body: three_times_body)
#     end
#   end
# end
