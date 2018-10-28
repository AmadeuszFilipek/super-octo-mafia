require_relative 'spec_helper'
require_relative 'scenario_part'

describe ScenarioPart do
  context "finding of all nested scenarios" do
    specify do
      part = ScenarioPart.new('./fixtures/scenarios/happy_path/')
      expect(part).not_to be_leaf

      sub1, sub2 = part.sub_parts
      expect(sub1).not_to be_leaf
      expect(sub2).not_to be_leaf

      sub1_1, sub1_2 = sub1.sub_parts
      expect(sub1_1).to be_leaf
      expect(sub1_2).to be_leaf
    end
  end
end
