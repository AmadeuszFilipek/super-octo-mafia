require 'paint'

class VerboseStepFormatter
  def initialize(output)
    @output = output
  end

  def step_started(step)
    output.print "--- #{step.name}: "
  end

  def step_ok(step)
    output.puts Paint["OK", :green]
  end

  def step_failed(step)
    puts Paint["FAILED", :red]
  end

  def step_diff(step, diff, request, response)
    output.puts
    output.puts diff.to_s(:color)
    output.puts
    output.puts '--- ' + Paint[request[:verb], :red] + ' ' + request[:uri] + ' -> ' + response.status.to_s
    output.print "--- #{step.name}: "
    output.puts Paint["FAILED", :red]
  end

  def ask_to_cache
    output.print Paint["----- cache response? ", :yellow]
  end

  def step_cached
    output.puts Paint["---> cached", :green]
  end

  def exiting
    output.puts Paint['Exiting!', :red]
  end

  def step_ended
    output.puts
  end

  private

  attr_reader :output
end

