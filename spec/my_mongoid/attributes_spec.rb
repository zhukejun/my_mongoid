describe MyMongoid::Attributes do
  let(:event_class) {
    Class.new {
      include MyMongoid::Document
      field :number
      def number=(n)
        self.attributes["number"] = n + 1
      end
    }
  }

  let(:attr){
    {"number" => 10 }
  }

  let(:event) {
    event_class.new(attr)
  }

  describe "#attributes" do
    it "#attributes should eq attr" do
      expect(event.attributes).to eq({"number" => 11 })
    end
  end

  describe "#read_attributes" do
    it "read attributes value" do
      expect(event.read_attribute(:number)).to eq(11)
    end
  end

  describe "#write_attributes" do
    it "write attributes value" do
      event.write_attribute(:number, 12)
      expect(event.read_attribute(:number)).to eq(12)
    end
  end

  describe "#process_attributes" do
    it "use process_attributes to mass assignment" do
      event.process_attributes :number => 10
      expect(event.number).to eq(11)
    end

    it "raise MyMongoid::UnknownAttributeError" do
      expect {
        event.process_attributes({:a => 2, :number => 12})
      }.to raise_error MyMongoid::UnknownAttributeError

      expect {
        event.process_attributes :unknown => 2
      }.to raise_error MyMongoid::UnknownAttributeError
    end
  end

  describe "#attributes=" do
    it " an alias of #process_attributes" do
      expect(event).to respond_to(:attributes=)
      event.attributes = { :number => 13 }
      expect(event.number).to eq(14)
    end
  end

end
