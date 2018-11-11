require 'pathname'
require_relative 'scenario_step'

class Scenario
  attr_reader :root_path

  def self.from_leaf(root_path, leaf_path)
    root_path = Pathname.new(root_path).expand_path
    leaf_path = Pathname.new(leaf_path).expand_path

    parts = leaf_path.ascend.take_while { |ls| ls != root_path }.reverse
    request_paths = parts.flat_map do |part|
      part.children.select do |child|
        child.file? && child.fnmatch?('*.request')
      end
    end.sort

    new(root_path, request_paths)
  end

  def name
    steps.last.relative_path.dirname.to_s
  end

  def steps
    @steps ||= request_paths.map do |request_path|
      ScenarioStep.from_request_path(self, request_path)
    end
  end

  private

  attr_reader :request_paths

  def initialize(root_path, request_paths)
    @root_path = Pathname.new(root_path).expand_path
    @request_paths = request_paths
  end
end

