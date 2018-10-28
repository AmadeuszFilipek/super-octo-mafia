
class ScenarioPart
  attr_reader :parent, :path

  def initialize(path, parent = nil)
    @path = path.chomp('/')
    @parent = parent
  end

  def sub_parts
    subdirectories.map { |path| ScenarioPart.new(path, self) }
  end

  def leaf?
    sub_parts.empty?
  end

  def to_s
    "<#{path} is_leaf=#{leaf?}>"
  end

  alias_method :inspect, :to_s

  private

  def subdirectories
    Dir[File.join(path, '*')].map { |p| p.chomp('/') }.select { |p| File.directory?(p) }.sort
  end
end
