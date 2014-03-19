describe MyMongoid::Fields do
  let(:event_class) {
    Class.new {
      include MyMongoid::Document

      field :a
      field :b
    }
  }

  describe ".field" do
    it "can declare a field using 'field' DSL" do
      expect(event_class.new({})).to be_an(event_class)
    end

    it "Should raise MyMongoid::DuplicateFieldError if a field is declared twice" do
      expect {
        event_class.send(:field,:a)
      }.to raise_error(MyMongoid::DuplicateFieldError)
    end
  end

  describe "generate accessors" do
    let(:attr) {
      { :a => 1, :b => 2 }
    }

    let(:event) {
       event_class.new(attr)
    }

    it "generate getter and setter" do
      expect(event).to respond_to(:a)
      expect(event).to respond_to(:a=)
    end

    it "get field a = 1" do
      expect(event.a).to eq(1)
    end

    it "set field b = 3 " do
      event.b = 3
      expect(event.b).to eq(3)
    end
  end

  describe ".fields" do
    it "return a hash" do
      expect(event_class.fields).to be_a(Hash)
    end

    it "keys is field name" do
      expect(event_class.fields.keys).to include("a")
    end

    it "values is MyMongoid::Field object" do
      expect(event_class.fields["a"]).to be_a(MyMongoid::Field)
    end

    it "returns a string for Field#name" do
      field = event_class.fields["a"]
      expect(field.name).to eq("a")
    end
  end

  describe "#_id" do
    it "All models should have the _id field automatically declared" do
      expect(event_class.new({})).to respond_to(:_id)
    end
  end

end