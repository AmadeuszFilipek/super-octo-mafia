require './spec_helper.rb'
require './request_parser.rb'
require './request_dumper.rb'

describe RequestDumper do
  let(:dumper) do
    parser = RequestParser.new(content)
    RequestDumper.new(
      verb: parser.verb,
      uri: parser.uri,
      headers: parser.headers,
      body: parser.body
    )
  end

  context "when all attributes are present" do
    let(:content) do
      <<~CONTENT
        DELETE /api/path/to/delete
        Header-One: Value One
        Header-Two: Value Two

        some body
      CONTENT
    end

    specify do
      expect(dumper.to_s).to eq content
    end
  end

  context "when headers are missing" do
    let(:content) do
      <<~CONTENT
        DELETE /api/path/to/delete

        some body
      CONTENT
    end

    specify do
      expect(dumper.to_s).to eq content
    end
  end

  context "when body is missing" do
    let(:content) do
      <<~CONTENT
      DELETE /api/path/to/delete
      Header-One: Value One
      Header-Two: Value Two
      CONTENT
    end

    specify do
      expect(dumper.to_s).to eq content
    end
  end

  context "when body and headers are missing" do
    let(:content) do
      <<~CONTENT
      DELETE /api/path/to/delete
      CONTENT
    end

    specify do
      expect(dumper.to_s).to eq content
    end
  end

end
