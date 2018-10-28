require_relative 'spec_helper'
require_relative 'scenarios_list'

describe ScenariosList do
  let(:list) { ScenariosList.new('./fixtures/scenarios') }

  it '#all' do
    scenarios = list.all
    expect(scenarios.length).to eq 6

    binding.pry
    scenarios.each do |scenario|
      # expect(scenario.steps.length).to eq 6
    end
    # binding.pry

    # expect(scenarios.length).to eq 4
  end
end
