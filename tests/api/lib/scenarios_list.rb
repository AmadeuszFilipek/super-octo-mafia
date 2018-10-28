# require_relative 'scenario_part'
require 'rake/file_list'

class ScenariosList
  attr_reader :path

  def initialize(path)
    @path = path
  end

  ::Scenario = Struct.new(:scenarios_root, :sub_scenarios) do
    def self.build_for(scenarios_root, leaf_path)
      paths = []
      current_path = leaf_path

      while File.realpath(scenarios_root) != File.realpath(current_path)
        paths.unshift current_path
        current_path = current_path.split('/')[0..-2].join('/')
      end

      sub_scenarios = paths.map { |path| SubScenario.new(path) }
      new(scenarios_root, sub_scenarios)
    end

    def steps
      sub_scenarios.flat_map(&:steps)
    end
  end

  ::SubScenario = Struct.new(:path) do
    def steps
      Dir[File.join(path, '*.{request,response}')].sort
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
