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
end
