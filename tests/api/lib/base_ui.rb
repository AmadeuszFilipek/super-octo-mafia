class BaseUI
  def initialize(output)
    @output = output
    @failed_scenarios = []
  end

  def scenario_started(_scenario) end

  def step_started(_step) end

  def step_ok(_step) end

  def step_response_differs(_step, _diff, _request, _response) end

  def ask_to_cache(step, diff, request, response) end

  def step_failed(_step); end

  def scenario_failed(_scenario) end

  def scenario_ended(_scenario) end

  def step_cached; end

  def step_ended; end

  def summary; end

  private

  attr_reader :output, :failed_scenarios
end

