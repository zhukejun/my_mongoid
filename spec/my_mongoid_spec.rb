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

  describe ".configuration" do
    it " return the MyMongoid::Configuration singleton" do
      expect(MyMongoid.configuration).to be_a(MyMongoid::Configuration)
    end
  end

  describe ".configure" do
    it "should yield MyMongoid.configuration to a block" do
      MyMongoid.configure do |c|
        expect(c).to eq(MyMongoid.configuration)
      end
    end
  end
end
