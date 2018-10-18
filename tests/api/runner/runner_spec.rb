require './run.rb'
require './request_parser.rb'
require './response_parser.rb'

shared_examples_for 'parsing body and headers' do
  it 'parses body and headers' do
    expect(parser.headers).to eq(
      'Header-One' => 'Value One',
      'Header-Two' => 'Value Two',
    )
    expect(parser.body).to eq 'some body'
  end
end

shared_examples_for 'parsing body' do
  it 'parses body and headers when headers are missing' do
    expect(parser.headers).to eq({})
    expect(parser.body).to eq 'some body'
  end
end

shared_examples_for 'parsing headers' do
  it 'parses body and headers when body is missing' do
    expect(parser.headers).to eq(
      'Header-One' => 'Value One',
      'Header-Two' => 'Value Two',
    )
    expect(parser.body).to eq ''
  end
end

describe ResponseParser do
  context "when info, body and headers are present" do
    let(:parser) do
      ResponseParser.new(<<~CONTENT)
        HTTP/1.0 500 INTERNAL SERVER ERROR
        Header-One: Value One
        Header-Two: Value Two

        some body
      CONTENT
    end

    it_behaves_like 'parsing body and headers'

    specify do
      expect(parser.http_version).to eq 'HTTP/1.0'
      expect(parser.status_code).to eq 500
      expect(parser.status_name).to eq 'INTERNAL SERVER ERROR'
    end
  end


  context 'when headers are missing' do
    let(:parser) do
      ResponseParser.new(<<~CONTENT)
        HTTP/1.0 500 INTERNAL SERVER ERROR

        some body
      CONTENT
    end

    it_behaves_like 'parsing body'

    specify do
      expect(parser.http_version).to eq 'HTTP/1.0'
      expect(parser.status_code).to eq 500
      expect(parser.status_name).to eq 'INTERNAL SERVER ERROR'
    end
  end

  context "when body is missing" do
    let(:parser) do
      ResponseParser.new(<<~CONTENT)
        HTTP/1.0 500 INTERNAL SERVER ERROR
        Header-One: Value One
        Header-Two: Value Two
      CONTENT
    end

    it_behaves_like 'parsing headers'

    specify do
      expect(parser.http_version).to eq 'HTTP/1.0'
      expect(parser.status_code).to eq 500
      expect(parser.status_name).to eq 'INTERNAL SERVER ERROR'
    end
  end
end

describe RequestParser do
  context "when body and headers are present" do
    let(:parser) do
      RequestParser.new(<<~CONTENT)
        DELETE /api/path/to/delete
        Header-One: Value One
        Header-Two: Value Two

        some body
      CONTENT
    end

    it_behaves_like 'parsing body and headers'

    it 'parses verb, uri, headers and body' do
      expect(parser.verb).to eq 'DELETE'
      expect(parser.uri).to eq '/api/path/to/delete'
    end
  end

  context "when headers are missing" do
    let(:parser) do
      RequestParser.new(<<~CONTENT)
        DELETE /api/path/to/delete

        some body
      CONTENT
    end

    it_behaves_like 'parsing body'

    it 'parses content without headers' do
      expect(parser.verb).to eq 'DELETE'
      expect(parser.uri).to eq '/api/path/to/delete'
    end
  end

  context "when body is missing" do
    let(:parser) do
      RequestParser.new(<<~CONTENT)
        DELETE /api/path/to/delete
        Header-One: Value One
        Header-Two: Value Two
      CONTENT
    end

    it_behaves_like 'parsing headers'

    it 'parses content without body' do
      expect(parser.verb).to eq 'DELETE'
      expect(parser.uri).to eq '/api/path/to/delete'
    end
  end

  # it 'parses content without body and headers' do
  #   parser = RequestParser.new(<<~CONTENT)
  #     DELETE /api/path/to/delete
  #   CONTENT

  #   expect(parser.verb).to eq 'DELETE'
  #   expect(parser.uri).to eq '/api/path/to/delete'
  #   expect(parser.headers).to eq({})
  #   expect(parser.body).to eq ''
  # end
end
