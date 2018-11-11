require 'paint'
require 'tty-pager'
require_relative 'base_ui'
require_relative 'errors'

class InteractiveUI < BaseUI
  def step_response_differs(step, diff, request, response)
    output.puts Paint['F', :red]

    content_to_page = [
      'Scenario: ' + Paint[step.scenario.name, :bold],
      "Response for step " + Paint[step.name, :yellow],
      '',
      diff.to_s(:color)
    ]

    tty_pager = TTY::Pager::SystemPager.new command: 'less -R'
    tty_pager.page(content_to_page.join("\n"))

    output.puts
    output.puts diff.to_s(:color)
    output.puts
  end

  def ask_to_cache(step, diff, request, response)
    output.puts 'Scenario: ' + Paint[step.scenario.name, :bold]
    output.puts '- Response for step ' + Paint[step.name, :yellow] + ' differs from cached version'
    output.print '  Do you want to save it? [n] '

    tty_reader.read_char.downcase == 'y'
  end

  def step_failed(_step)
    output.puts
    output.puts
    raise StepFailed
  end

  def step_cached(_step)
    output.puts Paint['---> cached', :green]
  end

  def step_ended(_step)
    output.puts
  end

  def exit_with_status
    exit 0
  end

  private

  def tty_reader
    @tty_reader ||= TTY::Reader.new
  end
end

