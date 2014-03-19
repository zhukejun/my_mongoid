module MyMongoid
  module Attributes

    def attributes
      @attributes ||= {}
    end

    def read_attribute(name)
      name = name.to_s
      attributes[name]
    end

    def write_attribute(name, value)
      name = name.to_s
      attributes[name] = value
    end

    def process_attributes(attr)
      attr.each do |name, value|
        name = name.to_s
        raise MyMongoid::UnknownAttributeError unless respond_to?name 
        send("#{name}=", value)
      end
    end
    alias :attributes= :process_attributes
  end
end
