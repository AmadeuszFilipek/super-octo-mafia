require './spec_helper.rb'
require './request_parser.rb'

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

  context 'when body and headers are missing' do
    let(:parser) do
      RequestParser.new(<<~CONTENT)
        DELETE /api/path/to/delete
      CONTENT
    end

    it_behaves_like 'parsing empty headers and empty body'

    it 'parses content without body and headers' do
      expect(parser.verb).to eq 'DELETE'
      expect(parser.uri).to eq '/api/path/to/delete'
    end
  end
end
