
class ScenarioPart
  attr_reader :path, :root

  def initialize(path, root:)
    @path = File.expand_path(path.chomp('/')).sub(root, '')
    @root = root
  end

  def ==(other_part)
    path == other_part.path
  end

  def parent
    @parent ||=
      begin
        parent_path = path.split('/')[0..-2].join('/')
        ScenarioPart.new(parent_path, root: root)
      end
  end

  def parts
    subdirectories.map { |path| ScenarioPart.new(path, root: root) }
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
