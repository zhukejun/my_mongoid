module MyMongoid
  module Attributes

    def clear_changed_attributes
      @changed_attributes = {}
    end

    def changed_attributes
      @changed_attributes ||= {}
    end

    def attributes
      @attributes ||= {}
    end

    def read_attribute(name)
      name = name.to_s
      attributes[name]
    end

    def write_attribute(name, value)
      name = name.to_s
      if self.class.attribute_types.has_key?(name)
        raise MyMongoid::AttributeTypeError unless value.is_a?(self.class.attribute_types[name])
      end
      changed_attributes[name] = [attributes[name],value] if attributes.has_key?(name) && attributes[name] != value && name!="_id"
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
