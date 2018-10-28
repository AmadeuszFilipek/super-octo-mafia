require_relative 'spec_helper'
require_relative 'scenario_list'

describe ScenarioList do
  context "finding of all nested scenarios" do
    specify do
      list = ScenarioList.new('./fixtures/scenarios/happy_path/')
      expect(list).not_to be_leaf

      sub1, sub2 = list.sub_lists
      expect(sub1).not_to be_leaf
      expect(sub2).not_to be_leaf

      sub1_1, sub1_2 = sub1.sub_lists
      binding.pry
      expect(sub1_1).to be_leaf
      expect(sub1_2).to be_leaf
    end
  end
end
