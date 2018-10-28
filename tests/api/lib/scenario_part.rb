
class ScenarioPart
  attr_reader :path

  def initialize(path)
    @path = path.chomp('/')
  end

  def ==(other_part)
    path == other_part.path
  end

  def parent
    @parent ||=
      begin
        parent_path = path.split('/')[0..-2].join('/')
        ScenarioPart.new(parent_path)
      end
  end

  def parts
    subdirectories.map { |path| ScenarioPart.new(path) }
  end

  def leaf?
    parts.empty?
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
