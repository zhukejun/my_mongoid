module MyMongoid
  module Fields
    extend ActiveSupport::Concern

    included do
      field :_id, :as => :id
    end

    module ClassMethods
      def field(name,options={})
        name = name.to_s
        raise MyMongoid::DuplicateFieldError if fields.has_key?(name)
        define_method(name.to_sym) do
          attributes[name] ||= self.class.default_attributes[name]
        end

        define_method("#{name}=".to_sym) do |value|
          write_attribute(name, value)
        end
        fields[name]=MyMongoid::Field.new(name,options)

        if options.has_key?(:as)
          alias_method options[:as].to_sym, name.to_sym
          alias_method "#{options[:as]}=".to_sym, "#{name}=".to_sym
        end

        if options.has_key?(:default)
          default_attributes[name] = options[:default]
        end

        if options.has_key?(:type)
          attribute_types[name] = options[:type]
        end


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
