require "active_support/core_ext"
require "active_support/inflector"

require "moped"

require "my_mongoid/version"
require "my_mongoid/document"
require "my_mongoid/configuration"
require "my_mongoid/sessions"

module MyMongoid
  # Your code goes here...
  extend self

  def models
    @models ||= []
  end

  def register_model(name)
    models << name unless models.include?(name)
  end
  def configuration
    Configuration.instance
  end

  def configure
    yield configuration if block_given?
  end

  def session
    raise MyMongoid::UnconfiguredDatabaseError if !MyMongoid.configuration.host || !MyMongoid.configuration.database
    @session ||= ::Moped::Session.new([MyMongoid.configuration.host],{:database => MyMongoid.configuration.database})
  end
end
