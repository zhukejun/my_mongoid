require 'moped'
module MyMongoid
  def self.session
    raise MyMongoid::UnconfiguredDatabaseError if !MyMongoid.configuration.host && !MyMongoid.configuration.database
    @session ||= ::Moped::Session.new([MyMongoid.configuration.host],{:database => MyMongoid.configuration.database})
  end
end
