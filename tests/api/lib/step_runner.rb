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
  def initialize(step)
    @step = step
  end

  def call
    request_name = File.basename(request_path)
    response_string = if File.exists?(response_path)
                               File.read(response_path)
                             else
                               ''
                             end

    request = RequestParser.new(File.read(request_path)).parse
    response = RequestExecutor.new(request).call

    dumper = ResponseDumper.new(OctoMafiaResponse.new response)
    actual_response_string = dumper.to_s
    diff = Diffy::Diff.new(response_string, actual_response_string)

    print "--- #{step.name}: "

    if diff.none?
      puts Paint["OK", :green]
    else
      puts Paint["FAILED", :red]
      puts
      puts diff.to_s(:color)
      puts
      puts '--- ' + Paint[request[:verb], :red] + ' ' + request[:uri] + ' -> ' + response.status.to_s
      print "--- #{request_name}: "
      puts Paint["FAILED", :red]
      print Paint["----- cache response? ", :yellow]

      if tty_reader.read_char.downcase == 'y'
        File.open(response_path, 'wb') { |f| f.write(actual_response_string) }
        puts Paint["---> cached", :green]
      else
        puts Paint['Exiting!', :red]
        exit 1
      end
      puts
    end
  end

  private

  attr_reader :step

  def request_path
    step.request_path
  end

  def response_path
    step.response_path
  end

  def tty_reader
    @tty_reader ||= TTY::Reader.new
  end
end

