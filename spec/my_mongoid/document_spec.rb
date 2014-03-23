describe MyMongoid::Document do
  before(:all) do
    MyMongoid.configure do |config|
      config.database = "my_mongoid"
      config.host = "localhost:27017"
    end

    class Event
      include MyMongoid::Document
      field :created_at
    end
  end

  after(:all) do
    Event.collection.drop
  end

  describe "Document modules" do
    it "is a module" do
      expect(MyMongoid::Document).to be_a(Module)
      expect(MyMongoid::Document::ClassMethods).to be_a(Module)
    end
  end

  describe ".is_mongoid_model?" do
    it "return true" do
      expect(Event.is_mongoid_model?).to be true
    end
  end

  describe ".new" do
    it "can instantiate a model with hash attributes" do
      expect(Event.new({})).to be_an(Event)
    end

    it "should throw ArgumentError " do
      expect {
        Event.new("abc")
      }.to raise_error(ArgumentError)
    end

    it "should correct init" do
      data={"created_at"=>"2014-02-13T03:20:37Z"}
      ev=Event.new(data) do |e|
        e.created_at = Time.parse(data["created_at"])
      end

      expect(ev.created_at).to eq(Time.parse("2014-02-13T03:20:37Z"))
    end
  end

  describe "#new_record?" do
    it "return true when first new" do
      expect(Event.new({}).new_record?).to be true
    end
  end

  describe ".collection_name" do
    it "should use active support's tableize method" do
      expect(Event.collection_name).to eq("events")
    end
  end

  describe ".collection" do
    it "should return a model's collection" do
      expect(Event.collection).to be_a(Moped::Collection)
      expect(Event.collection.name).to eq("events")
    end
  end

  describe "#to_document" do
    it "should be a bson document" do
      event = Event.new({:created_at => "2014-02-02",:_id => "abc"})
      expect(event.to_document).to eql({"created_at" => "2014-02-02", "_id" => "abc"})
    end
  end

  describe "#save" do
    context "successful insert" do
      it "should insert a new record into the db" do
        col = Event.collection
        event = Event.new({:created_at => "zkj"})
        expect {
          event.save
        }.to change{col.find.count}.by(1)
      end

      it "should return true" do
        event = Event.new({:created_at => "zkj"})
        expect(event.save).to eq(true)
      end

      it "should make Model#new_record return false" do
        event = Event.new({:created_at => "zkj"})
        expect(event.new_record?).to eq(true)
        event.save
        expect(event.new_record?).to eq(false)
      end

      it "should saving a record with no id: a random id" do
        event = Event.new({:created_at => "zkj"})
        event.save
        expect(event.id).to be_a(BSON::ObjectId)
        expect(Event.collection.find({"_id" => event.id}).count).to eq(1)
      end

      it "should have no changes right after persisting" do
        event = Event.new({:created_at => "zkj"})
        event.save
        expect(event.changed?).to eq(false)
      end
    end
  end

  describe ".create" do
    it "should return a saved recored" do
      col = Event.collection
      expect {
        Event.create({:created_at => "zkj" })
      }.to change{col.find.count}.by(1)
      event = Event.create({:created_at => "zkj"})
      expect(event).to_not be_new_record
    end
  end

  describe ".instantiate" do
    it "should return a model instance" do
      expect(Event.instantiate).to be_a(Event)
    end

    it "should return an instance that's not a new_record" do
      expect(Event.instantiate).to_not be_new_record
    end

    it "should have the given attributes" do
      event = Event.instantiate({:created_at => "zkj"})
      expect(event.attributes).to eq({"created_at" => "zkj"})
      expect(event.created_at).to eq("zkj")
    end

  end

  describe ".find" do

    it "should be able to find a record by issuing query" do
      event = Event.create
      result = Event.find({"_id" => event.id})
      expect(result.id).to eq(event.id)
    end

    it "shuld be able to find a record by issuing shorthand id query" do
      event = Event.create
      result = Event.find(event.id)
      expect(result.id).to eq(event.id)
    end

    it "should raise MyMongoid::RecordNotFoundError if nothing is found for an id" do
      Event.create
      expect { Event.find(1) }.to raise_error MyMongoid::RecordNotFoundError
    end
  end

  describe "#changed_attributes" do
    let(:event) {
      Event.new({"created_at" => "zkj"})
    }
    it "should be an empty hash initially" do
      expect(event.changed_attributes).to be_a(Hash)
    end

    it "should track writes to attributes" do
      event.created_at = "xyp"
      expect(event.changed_attributes.keys).to include("created_at")
    end

    it "should keep the original attribute values" do
      event.created_at = "xyp"
      expect(event.changed_attributes["created_at"]).to eq("zkj")
    end

    it "should not make a field dirty if the assigned value is equaled to the old value"do
      event.created_at = "zkj"
      expect(event.changed_attributes.keys).to_not include("created_at")
    end
  end

  describe "#changed?" do
    it 'should be false for a newly instantiated record' do
      e = Event.new(created_at: "A")
      expect(e.changed?).to be false
    end
    it "should be true if a field changed" do
      e = Event.new(created_at: "A")
      e.created_at = "C"
      expect(e.changed?).to be true
    end
  end

  describe "#atomic_updates" do
    it "should return {} if nothing changed" do
      e = Event.new(created_at: "A")
      expect(e.atomic_updates).to eq({})
    end

    it "should return {} if record is not a persisted document" do
      e = Event.new(created_at: "A")
    end

    it "should generate the $set update operation to update a persisted document" do
      e = Event.new(created_at: "A")
    end



  end

end
