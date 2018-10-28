
class ScenarioPart
  def initialize(path, parent = nil)
    @path = path
    @parent = parent
  end

  def sub_parts
    Dir[File.join(path, '*')].select { |p| File.directory?(p) }.map do |path|
      ScenarioPart.new(path, self)
    end
  end

  def leaf?
    sub_parts.empty?
  end

  def to_s
    "<#{path} is_leaf=#{leaf?}>"
  end

  alias_method :inspect, :to_s

  private

  attr_reader :path, :parent
end
