module MyMongoid
  module Attributes
    extend ActiveSupport::Concern

    def attributes
      @attributes ||= {}
    end

    def read_attribute(name)
      @attributes[name]
    end

    def write_attribute(name, value)
      @attributes[name] = value
    end

    module ClassMethods
    end
  end
end
