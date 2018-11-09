require_relative 'errors'
require_relative 'base_ui'

class LoggingUI < BaseUI
  def step_response_differs(step, diff, _request, _response)
    output.puts
    output.puts diff.to_s(:color)
    output.puts
  end

  def ask_to_cache(_step, _diff, _request, _response)
    false
  end

  def step_failed(_step)
    raise StepFailed
  end

  def scenario_failed(scenario)
    failed_scenarios.push(scenario)
  end

  def summary
    output.puts '--------------------------------'
    output.puts

    if failed_scenarios.any?
      output.puts Paint["#{failed_scenarios.length} scenarios have failed.", :red]
      output.puts failed_scenarios.map { |scenario|
        Paint[" - #{scenario.name}", :bold] # + Paint[' failed!', :red]
      }.join("\n")
    end
  end
end
