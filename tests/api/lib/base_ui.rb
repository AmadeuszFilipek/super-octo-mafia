class BaseUI
  def initialize(output)
    @output = output
    @failed_scenarios = []
  end

  def scenario_started(scenario)
    output.print Paint["- #{scenario.name}", :bold]
    output.print ' '
  end

  def step_started(_step) end

  def step_ok(step)
    output.print Paint['.', :green]
  end

  def step_response_differs(_step, _diff, _request, _response) end

  def ask_to_cache(step, diff, request, response) end

  def step_failed(_step); end

  def scenario_failed(_scenario) end

  def scenario_ended(_scenario)
    output.puts
  end

  def step_cached(_step); end

  def step_ended(_step); end

  def summary
    output.puts

    if failed_scenarios.empty?
      output.puts Paint["All scenarios passed.", :green]
    else
      print_failed_scenarios
    end
  end

  def exit_with_status; end

  private

  attr_reader :output, :failed_scenarios

  def print_failed_scenarios
    output.puts Paint["#{failed_scenarios.length} scenarios have failed.", :red]
    output.puts failed_scenarios.map { |scenario|
      Paint[" - #{scenario.name}", :bold] # + Paint[' failed!', :red]
    }.join("\n")
  end
end

