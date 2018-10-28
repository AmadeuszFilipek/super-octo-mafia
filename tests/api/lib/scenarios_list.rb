require_relative 'scenario_part'

class ScenariosList
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def all
    leaves.map do |leaf|
      full_path = File.expand_path(self.path)
      leaf_path = File.expand_path(leaf.path)

      diff_path = leaf_path.sub(full_path, '')
      path_parts = diff_path.split('/')[1..-1]

      path_parts.map.with_index do |part, idx|
        ScenarioPart.new(File.join(full_path, path_parts[0..idx].join('/')))
      end
    end
  end

  def ==(other)
    File.expand_path(path) == File.expand_path(other.path)
  end

  private

  def leaves
    parts.select(&:leaf?)
  end

  def parts
    subdirectories.map { |subdirectory| ScenarioPart.new(subdirectory) }
  end

  def subdirectories
    Dir[File.join(path, '**/**')].map { |p| p.chomp('/') }.select { |p| File.directory?(p) }.sort
  end
end
