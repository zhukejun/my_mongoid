require 'spec_helper'

describe MyMongoid do
  let(:model) {
    Class.new {
      include MyMongoid::Document
    }
  }

  describe ".models" do
    it "should be array and include model class" do
      expect(MyMongoid.models).to be_a(Array)
      expect(MyMongoid.models).to include(model)
    end
  end
end
