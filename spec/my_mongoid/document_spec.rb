describe MyMongoid::Document do
  let(:event) {
    Class.new {
      include MyMongoid::Document
      field :created_at
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
      expect(event.is_mongoid_model?).to be true
    end
  end

  describe ".new" do
    it "can instantiate a model with hash attributes" do
      expect(event.new({})).to be_an(event)
    end

    it "should throw ArgumentError " do
      expect {
        event.new("abc")
      }.to raise_error(ArgumentError)
    end

    it "should correct init" do
      data={"created_at"=>"2014-02-13T03:20:37Z"}
      e = event.new(data) do |e|
        e.created_at = Time.parse(data["created_at"])
      end

      expect(e.created_at).to eq(Time.parse("2014-02-13T03:20:37Z"))
    end
  end

  describe "#new_record?" do
    it "return true when first new" do
      expect(event.new({}).new_record?).to be true
    end
  end

end
