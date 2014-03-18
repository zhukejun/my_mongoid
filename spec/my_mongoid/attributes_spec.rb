describe MyMongoid::Attributes do
  let(:event_class) {
    Class.new {
      include MyMongoid::Document
    }
  }  

  let(:attr){
    {:name => "zkj", :email => "zkj@zkj.com"}
  }

  describe "#attributes" do
    it "#attributes should eq attr" do
      event = event_class.new(attr)
      expect(event.attributes).to eq({:name => "zkj", :email => "zkj@zkj.com"})
    end
  end

  describe "#read_attributes" do
    it "read attributes value" do
      event = event_class.new(attr)
      expect(event.read_attribute(:name)).to eq("zkj")
    end
  end

  describe "#write_attributes" do
    it "write attributes value" do
      event = event_class.new(attr)
      event.write_attribute(:name,"xyp")
      expect(event.read_attribute(:name)).to eq("xyp")
    end
  end


end
