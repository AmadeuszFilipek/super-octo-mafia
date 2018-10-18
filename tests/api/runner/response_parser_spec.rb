require './spec_helper.rb'
require './response_parser.rb'

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

  context "when body and headers are missing" do
    let(:parser) do
      ResponseParser.new(<<~CONTENT)
        HTTP/1.0 500 INTERNAL SERVER ERROR
      CONTENT
    end

    it_behaves_like 'parsing empty headers and empty body'

    specify do
      expect(parser.http_version).to eq 'HTTP/1.0'
      expect(parser.status_code).to eq 500
      expect(parser.status_name).to eq 'INTERNAL SERVER ERROR'
    end
  end
end

