require "active_support/core_ext"

require "my_mongoid/version"
require "my_mongoid/document"

module MyMongoid
  # Your code goes here...
  class << self
    def models
      @models ||= []
    end

    def register_model(name)
      models << name unless models.include?(name)
    end
  end
end
