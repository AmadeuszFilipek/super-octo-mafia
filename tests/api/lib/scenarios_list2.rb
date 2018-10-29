# require_relative 'scenario_part'
require 'rake/file_list'
require 'pathname'

class ScenariosList
  attr_reader :path

  def initialize(path)
    @path = "#{path.chomp('/')}/"
  end

  ::Scenario = Struct.new(:scenarios_root, :sub_scenarios) do
    def self.build_for(scenarios_root, leaf_path)
      paths = []
      current_path = leaf_path

      while File.realpath(scenarios_root) != File.realpath(current_path)
        paths.unshift current_path
        current_path = current_path.split('/')[0..-2].join('/')
      end

      sub_scenarios = paths.map do |sub_scenario_path|
        relative_path = sub_scenario_path.sub(scenarios_root, '')

        SubScenario.new(scenarios_root, relative_path)
      end

      new(scenarios_root, sub_scenarios)
    end

    def steps
      sub_scenarios.flat_map(&:steps)
    end

    def name
      sub_scenarios.last.path
    end
  end

  ::ScenarioStep = Struct.new(:scenarios_root, :name) do
    def request_path
      File.join(scenarios_root, name) + '.request'
    end

    def response_path
      File.join(scenarios_root, name) + '.response'
    end
  end

  ::SubScenario = Struct.new(:scenarios_root, :path) do
    def steps
      Dir[File.join(scenarios_root, path, '*.{request,response}')].sort.map do |step_path|
        step_path.sub(scenarios_root, '').sub(/\.(request|response)/, '')
      end.map do |step_path|
        ScenarioStep.new(scenarios_root, step_path)
      end
    end
  end

  def all
    leaf_subdirectories.map do |leaf_subdir|
      Scenario.build_for(path, leaf_subdir)
    end
  end


  def leaf_subdirectories
    subdirectories.select do |subdir|
      Dir[File.join(subdir, '**/**')].none? { |p| File.directory?(p) }
    end
  end

  def subdirectories
    Dir[File.join(path, '**/**')].map { |p| p.chomp('/') }.select { |p| File.directory?(p) }.sort
  end
end
