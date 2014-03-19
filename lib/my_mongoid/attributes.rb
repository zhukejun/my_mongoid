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
        #write_attribute(name, value)
        name = name.to_s
        send("#{name}=", value)
      end
    end

  end
end
