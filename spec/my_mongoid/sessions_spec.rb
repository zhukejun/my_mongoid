describe "MyMongoid::Sessions" do

  before(:all) do
    MyMongoid.configure do |config|
      config.database = "my_mongoid"
      config.host = "localhost:27017"
    end
  end


  it "should return a Moped::Session" do
    expect(MyMongoid.session).to be_a(Moped::Session)
  end

  it "should memoize the session @session" do
    expect(MyMongoid.session).to eq(MyMongoid.session)
  end

  it "raise MyMongoid::UnconfiguredDatabaseError if host and database are not configured" do

    MyMongoid.configure do |config|
      config.database =  "my_mongoid"
      config.host = nil
    end
    expect {
      MyMongoid.session
    }.to raise_error MyMongoid::UnconfiguredDatabaseError
  end
end
