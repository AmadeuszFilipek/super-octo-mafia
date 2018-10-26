require_relative 'request_dumper'

class RequestRecorder
  def initialize(requests_path)
    @requests_path = requests_path
    @request_index = 0
  end

  def record(request)
    FileUtils.mkdir_p(requests_path)

    File.open(new_request_path, 'wb') do |f|
      f.write RequestDumper.new(request).to_s
    end
  end

  private

  attr_reader :requests_path

  def new_request_path
    @request_index+= 1
    new_request_name = sprintf("%03d", @request_index)

    "./#{requests_path}/#{new_request_name}.request"
  end
end
