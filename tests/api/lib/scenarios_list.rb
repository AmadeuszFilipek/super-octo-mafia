require 'pathname'
require_relative 'scenario'

class ScenariosList
  attr_reader :root_path

  def initialize(root_path)
    @root_path = Pathname.new(root_path).expand_path
  end

  def all
    leaf_subdirectories.map do |leaf_subdirectory|
      Scenario.from_leaf(root_path, leaf_subdirectory)
    end.sort_by(&:name)
  end

  private

  def leaf_subdirectories
    Dir[root_path.join('**/**')]
      .map { |p| Pathname.new(p).expand_path }
      .select { |p| p.directory? && p.children.all?(&:file?) }
  end
end

