require_relative 'step_runner'

class ScenarioRunner
  def initialize(scenario, ui:)
    @scenario = scenario
    @ui = ui
  end

  def call
    ui.scenario_started(scenario)

    scenario.steps.each do |step|
      StepRunner.new(step, ui: ui).call
    end
    ui.scenario_passed(scenario)
  rescue StepFailed
    ui.scenario_failed(scenario)
  end

  private

  attr_reader :scenario, :ui
end
