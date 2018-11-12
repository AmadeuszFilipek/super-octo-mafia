require 'pathname'

class ScenarioStep
  attr_reader :step_path, :scenario

  def self.from_request_path(scenario, request_path)
    step_path = Pathname.new(request_path).sub_ext('')

    new(scenario, step_path)
  end

  def root_path
    scenario.root_path
  end

  def name
    relative_path.to_s
  end

  def relative_path
    step_path.relative_path_from(root_path)
  end

  def to_s
    relative_path.to_s
  end
  alias_method :inspect, :to_s

  def request_path
    step_path.sub_ext '.request'
  end

  def response_path
    step_path.sub_ext '.response'
  end

  private

  def initialize(scenario, step_path)
    @scenario = scenario
    @step_path = Pathname.new(step_path).expand_path
  end
end

