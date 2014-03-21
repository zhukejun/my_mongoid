describe MyMongoid::Configuration do
  let(:config_class) { MyMongoid::Configuration}
  it "should be a singleton class" do
    expect { config_class.new }.to raise_error NoMethodError
    a,b  = config_class.instance, config_class.instance
    expect(a).to eq(b)
  end

  describe "#host" do
    it "have #host accessor" do
      expect(config_class.instance).to respond_to(:host)
      expect(config_class.instance).to respond_to(:host=)
    end
  end

  describe "#database" do
    it "have #database accessor" do
      expect(config_class.instance).to respond_to(:database)
      expect(config_class.instance).to respond_to(:database=)
    end
  end


end
