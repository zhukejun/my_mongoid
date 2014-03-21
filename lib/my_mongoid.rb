require "active_support/core_ext"

require "my_mongoid/version"
require "my_mongoid/document"
require "my_mongoid/configuration"
require "my_mongoid/session"

module MyMongoid
  # Your code goes here...
  class << self
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
  end
end
