require 'pry'
require 'pathname'

ScenarioStep = Struct.new(:root_path, :step_path) do
  def self.from_request_path(root_path, request_path)
    step_path = Pathname.new(request_path).sub_ext('')

    new(root_path, step_path)
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
end

Scenario = Struct.new(:root_path, :steps) do
  def self.from_leaf(root_path, leaf_path)
    root_path = Pathname.new(root_path).expand_path
    leaf_path = Pathname.new(leaf_path).expand_path

    parts = leaf_path.ascend.take_while { |ls| ls != root_path }.reverse
    request_paths = parts.flat_map do |part|
      part.children.select do |child|
        child.file? && child.fnmatch?('*.request')
      end
    end

    steps = request_paths.map do |request_path|
      ScenarioStep.from_request_path(root_path, request_path)
    end

    new(root_path, steps)
  end

  def name
    steps.last.relative_path.dirname.to_s
  end
end

class ScenariosList
  def initialize(root_path)
    @root_path = Pathname.new(root_path).expand_path
  end

  def all
    leaf_subdirectories.map do |leaf_subdirectory|
      Scenario.from_leaf(root_path, leaf_subdirectory)
    end.sort_by(&:name)
  end

  private

  attr_reader :root_path

  def leaf_subdirectories
    Dir[root_path.join('**/**')]
      .map { |p| Pathname.new(p).expand_path }
      .select { |p| p.directory? && p.children.all?(&:file?) }
  end
end

describe ScenariosList do
  it "#all returns all scenarios" do
    list = ScenariosList.new('./fixtures/scenarios')
    scenarios = list.all

    expect(scenarios.length).to eq 6

    # scenarios have steps pointing to existing files
    scenarios.each do |scenario|
      scenario.steps.each do |step|
        expect(File.exist?(step.request_path)).to be_truthy
        expect(File.file?(step.request_path)).to be_truthy

        expect(File.exist?(step.response_path)).to be_truthy
        expect(File.file?(step.response_path)).to be_truthy
      end
    end

    s1, s2, s3, s4, s5, s6 = scenarios

    # scenarios have proper names
    expect(s1.name).to eq 'error_path/second_level/third_level'
    expect(s2.name).to eq 'error_path/second_level_2/third_level_2'
    expect(s3.name).to eq 'happy_path/part1/part1_1'
    expect(s4.name).to eq 'happy_path/part1/part1_2'
    expect(s5.name).to eq 'happy_path/part2/part2_1'
    expect(s6.name).to eq 'happy_path/part2/part2_2'
  end
end
