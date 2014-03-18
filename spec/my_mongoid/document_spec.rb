describe MyMongoid::Document do
  let(:event) {
    Class.new {
      include MyMongoid::Document
    }
  }

  describe "Document modules" do
    it "is a module" do
      expect(MyMongoid::Document).to be_a(Module)
      expect(MyMongoid::Document::ClassMethods).to be_a(Module)
    end
  end

  describe ".is_mongoid_model?" do
    it "return true" do
      expect(event.is_mongoid_model?).to eq(true)
    end
  end

  describe ".new" do
    context "when initialize a Mongoid model with atrrtibutes" do
      it "can instantiate a model with hash attributes" do
        expect(event.new({})).to be_an(event)
      end
    end
    context "when initialize argument is not hash" do
      it "should throw ArgumentError " do
        expect { event.new("abc") }.to raise_error(ArgumentError) 
      end
    end
  end

  describe "#new_record?" do
    it "return true when first new" do
      expect (event.new({}).new_record?).to eq(true)
    end
  end

end
