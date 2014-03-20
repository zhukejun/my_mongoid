describe MyMongoid::Fields do
  let(:event_class) {
    Class.new {
      include MyMongoid::Document

      field :a, :as => :n
      field :b, :default => "normal"
      field :time, :type => Time
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

    context "parse options" do
      it "store the field options in Field object" do
        expect(event_class.fields["a"].options).to include(:as => :n)
      end

      it 'aliiases a field with :as option' do
        event = event_class.new(:a => 10)
        expect(event.a).to eq(10)
        expect(event.n).to eq(10)
        event.n=20
        expect(event.a).to eq(20)
        expect(event.n).to eq(20)
      end

      it 'add field default value' do
        expect(event_class.new({}).b).to eq("normal")
      end

      context "when add filed type options" do
        it 'Raise an error if type mismatches' do
          expect {
            event_class.new(:time => 10)
          }.to raise_error MyMongoid::AttributeTypeError
        end

        it 'not raise error if type matches' do
          expect {
            event_class.new(:time => Time.now)
          }.to_not raise_error
        end
      end
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
    it 'make id the alias for _id ' do
      expect(event_class.new({})).to respond_to(:id)
    end

  end

end
