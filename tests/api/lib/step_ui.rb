require 'paint'
require 'tty-pager'

class StepUI
  def initialize(output)
    @output = output
  end

  def started(*) end

  def ok(step)
    output.print Paint['.', :green]
  end

  def failed(step)
    output.puts Paint['F', :red]
  end

  def show_diff(step, diff, request, response)
    tty_pager = TTY::Pager::SystemPager.new command: 'less -R'
    tty_pager.page(diff.to_s(:color))

    output.puts
    output.puts diff.to_s(:color)
    output.puts
  end

  def ask_to_cache(step, diff, request, response)
    output.puts '- Response for ' + Paint[step.name, :yellow] + ' differs from cached version'
    output.print '  Do you want to save it? [n] '

    tty_reader.read_char.downcase == 'y'
  end

  def step_cached
    output.puts Paint["---> cached", :green]
  end

  def exiting
    output.puts Paint['Exiting!', :red]
  end

  def step_ended
    output.puts
  end

  private

  attr_reader :output

  def tty_reader
    @tty_reader ||= TTY::Reader.new
  end
end
