module MyMongoid
  module Attributes
    extend ActiveSupport::Concern

    def attributes
      @attributes ||= {}
    end

    def read_attribute(name)
      name = name.to_sym
      @attributes[name]
    end

    def write_attribute(name, value)
      name = name.to_sym
      @attributes[name] = value
    end

    def process_attributes(attr)
      attr.each do |name, value|
        #write_attribute(name, value)
        name = name.to_s
        send("#{name}=", value)
      end
    end

    module ClassMethods

    end
  end
end
