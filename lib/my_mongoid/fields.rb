module MyMongoid
  module Fields
    extend ActiveSupport::Concern

    included do
      field :_id, :as => :id
    end

    module ClassMethods
      def field(name, options = {})
        add_field(name, options)
      end

      def attribute_types
        @attribute_types ||= {}
      end

      def default_attributes
        @default_attributes ||= {}
      end

      def fields
        @fields ||= {}
      end

      protected
      def add_field(name, options)
        name = name.to_s
        raise MyMongoid::DuplicateFieldError if fields.has_key?(name)
        create_accessor(name)
        fields[name]=MyMongoid::Field.new(name,options)
        parse_options(name,options)
      end

      def create_accessor(name)
        create_getter(name)
        create_setter(name)
      end

      def create_getter(name)
        define_method(name.to_sym) do
          attributes[name] ||= self.class.default_attributes[name]
        end
      end

      def create_setter(name)
        define_method("#{name}=".to_sym) do |value|
          write_attribute(name, value)
        end
      end

      def parse_options(name, options)
        options.each do |k, v|
          case k
          when :as
            define_alias_method(v, name)
          when :default
            default_attributes[name] = v
          when :type
            attribute_types[name] = v
          else
          end
        end
      end

      def define_alias_method(new_name, name)
        alias_method new_name.to_sym, name.to_sym
        alias_method "#{new_name}=".to_sym, "#{name}=".to_sym
      end
    end
  end

  class Field
    attr_reader :name
    attr_reader :options
    def initialize(name,options={})
      @name=name.to_s
      @options=options
    end
  end
end
