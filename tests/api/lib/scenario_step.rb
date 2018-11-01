require 'pathname'

class ScenarioStep
  attr_reader :root_path, :step_path

  def self.from_request_path(root_path, request_path)
    step_path = Pathname.new(request_path).sub_ext('')

    new(root_path, step_path)
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

  def initialize(root_path, step_path)
    @root_path = Pathname.new(root_path).expand_path
    @step_path = Pathname.new(step_path).expand_path
  end
end

