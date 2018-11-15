require_relative 'request_parser'
require_relative 'request_dumper'
require_relative 'response_parser'
require_relative 'response_dumper'

describe "Integration of dumpers with parsers" do
  describe "Request" do
    Dir['./fixtures/*.request'].each do |request_path|
      it request_path do
        original_content = File.read(request_path).strip

        parser = RequestParser.new(original_content)
        request = parser.parse

        dumper = RequestDumper.new(request)
        dumped_content = dumper.to_s.strip

        expect(dumped_content).to eq original_content
      end
    end
  end

  describe "Response" do
    Dir['./fixtures/*.response'].each do |request_path|
      it request_path do
        original_content = File.read(request_path).strip

        parser = ResponseParser.new(original_content)
        response = parser.parse

        dumper = ResponseDumper.new(response)
        dumped_content = dumper.to_s.strip

        expect(dumped_content).to eq original_content
      end
    end
  end
end
