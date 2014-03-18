require "my_mongoid/attributes"

module MyMongoid

  module Document
    extend ActiveSupport::Concern
    
    include MyMongoid::Attributes

    included do
      MyMongoid.register_model(self)
    end

    module ClassMethods
      def is_mongoid_model?
        true
      end

    end

    def initialize(attrs = {})
      raise ArgumentError unless attrs.is_a?(Hash)
      attrs.each do |name, value|
        attributes[name] = value
      end
    end

    def new_record?
      true
    end
  end
end
