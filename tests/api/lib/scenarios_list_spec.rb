require_relative 'spec_helper'
require_relative 'scenarios_list'

describe ScenariosList do
  let(:list) { ScenariosList.new('./fixtures/scenarios') }

  def expect_scenario_paths_exist(scenario)
    scenario.steps.each do |step|
      expect(File.exists?(step.request_path)).to be_truthy
    end
  end

  it '#all' do
    scenarios = list.all
    expect(scenarios.length).to eq 6

    s1, s2, s3, s4, s5, s6 = scenarios

    expect(s1.name).to eq 'error_path/second_level/third_level'
    expect_scenario_paths_exist(s1)

    expect(s2.name).to eq 'error_path/second_level_2/third_level_2'
    expect_scenario_paths_exist(s2)

    expect(s3.name).to eq 'happy_path/part1/part1_1'
    expect_scenario_paths_exist(s3)

    expect(s4.name).to eq 'happy_path/part1/part1_2'
    expect_scenario_paths_exist(s4)

    expect(s5.name).to eq 'happy_path/part2/part2_1'
    expect_scenario_paths_exist(s5)

    expect(s6.name).to eq 'happy_path/part2/part2_2'
    expect_scenario_paths_exist(s6)
  end
end
