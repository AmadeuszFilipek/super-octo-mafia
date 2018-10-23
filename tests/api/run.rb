class RequestFile

end

class StoryRunner
  def self.run(args, stdout, stderr)
    new(StoryOptions.new(args), stdout, stderr).run
  end

  def requests
    @requests ||= Dir[story_path.join('requests/*')].map do |path|
      RequestFile.parse_load(path)
    end
  end

  def response_for(request)

  end
end

StoryRunner.run(ARGV, $stdout, $stderr)
