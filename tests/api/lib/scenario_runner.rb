require_relative 'step_runner'

class ScenarioRunner
  def initialize(scenario, ui:)
    @scenario = scenario
    @ui = ui
  end

  def call
    ui.started(scenario)

    scenario.steps.each do |step|
      StepRunner.new(step, ui: ui.step_ui).call
    end

    ui.ended(scenario)
  end

  private

  attr_reader :scenario, :ui
end
