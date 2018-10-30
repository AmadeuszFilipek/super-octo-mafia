require 'paint'

class StepFormatter
  def initialize(output)
    @output = output
  end

  def step_started(step)
    output.print "--- #{step.name}: "
  end

  def step_same_as_cached(step)
    output.puts Paint["OK", :green]
  end

  def step_different_as_cached(step, diff, request, response)
    puts Paint["FAILED", :red]
    puts
    puts diff.to_s(:color)
    puts
    puts '--- ' + Paint[request[:verb], :red] + ' ' + request[:uri] + ' -> ' + response.status.to_s
    print "--- #{step.name}: "
    puts Paint["FAILED", :red]
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

