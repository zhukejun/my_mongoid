describe "MyMongoid.session" do


  it "should return a Moped::Session" do
    expect(MyMongoid.session).to be_a(Moped::Session)
  end

  it "should memoize the session @session" do
    expect(MyMongoid.session).to eq(MyMongoid.session)
  end

  it "raise MyMongoid::UnconfiguredDatabaseError if host and database are not configured" do
    expect {
      MyMongoid.session
    }.to raise_error MyMongoid::UnconfiguredDatabaseError
  end
end
