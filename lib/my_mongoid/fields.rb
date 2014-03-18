module MyMongoid
  module Fields
    extend ActiveSupport::Concern

    included do
      field :_id
    end

    module ClassMethods
      def field(name)
        raise MyMongoid::DuplicateFieldError if fields.has_key?(name)
          define_method(name.to_sym) do
            attributes[name]
          end

          define_method("#{name}=".to_sym) do |value|
            write_attribute(name, value)
          end
          fields[name]=MyMongoid::Field.new(name)

      end

      def fields
        @fields ||= {}
      end
    end
  end

  class Field
    attr_reader :name
    def initialize(name)
      @name=name.to_s
    end
  end
end
