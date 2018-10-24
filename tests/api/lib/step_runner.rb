require 'http'
require 'json'
require 'diffy'
require 'paint'
require 'tty-reader'
require_relative 'request_dumper'
require_relative 'request_parser'
require_relative 'response_dumper'
require_relative 'response_parser'
require_relative 'request_executor'
require_relative 'octo_mafia_response'

class StepRunner
  def initialize(step_path)
    @step_path = step_path
  end

  def call
    FileUtils.mkdir_p('./responses')
    step_name = File.basename(step_path)
    cached_response_path = "./responses/#{step_name}"
    cached_response_string = if File.exists?(cached_response_path)
                               File.read(cached_response_path)
                             else
                               ''
                             end

    request = RequestParser.new(File.read(step_path)).parse
    response = RequestExecutor.new(request).call

    dumper = ResponseDumper.new(OctoMafiaResponse.new response)
    actual_response_string = dumper.to_s
    diff = Diffy::Diff.new(cached_response_string, actual_response_string)

    print "--- #{step_name}: "

    if diff.none?
      puts Paint["OK", :green]
    else
      puts Paint["FAILED", :red]
      puts
      puts diff.to_s(:color)
      puts
      puts '--- ' + Paint[request[:verb], :red] + ' ' + request[:uri] + ' -> ' + response.status.to_s
      print Paint["----- cache response? ", :yellow]

      if tty_reader.read_char.downcase == 'y'
        File.open(cached_response_path, 'wb') { |f| f.write(actual_response_string) }
        puts Paint["---> cached", :green]
      end
      puts
    end
  end

  private

  attr_reader :step_path

  def tty_reader
    @tty_reader ||= TTY::Reader.new
  end
end

