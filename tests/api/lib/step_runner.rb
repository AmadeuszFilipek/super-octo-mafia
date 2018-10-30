require 'diffy'
require 'tty-reader'
require_relative 'verbose_step_formatter'
require_relative 'request_dumper'
require_relative 'request_parser'
require_relative 'response_dumper'
require_relative 'response_parser'
require_relative 'request_executor'
require_relative 'octo_mafia_response'

class StepRunner
  def initialize(step, formatter: VerboseStepFormatter.new(STDOUT))
    @step = step
    @formatter = formatter
  end

  def call
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

    formatter.step_started(step)

    if diff.none?
      formatter.step_ok(step)
    else
      formatter.step_failed(step)
      formatter.step_diff(step, diff, request, response)

      formatter.ask_to_cache(step, diff, request, response)

      if tty_reader.read_char.downcase == 'y'
        File.open(response_path, 'wb') { |f| f.write(actual_response_string) }
        formatter.step_cached
      else
        formatter.exiting
        exit 1
      end
      formatter.step_ended
    end
  end

  private

  attr_reader :step, :formatter

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

