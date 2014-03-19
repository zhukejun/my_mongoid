require "my_mongoid/attributes"
require "my_mongoid/fields"
require "my_mongoid/error"
module MyMongoid

  module Document
    extend ActiveSupport::Concern

    include MyMongoid::Attributes
    include MyMongoid::Fields

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
      process_attributes attrs
    end

    def new_record?
      true
    end
  end
end
