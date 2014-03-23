require "my_mongoid/attributes"
require "my_mongoid/fields"
require "my_mongoid/error"
require "my_mongoid/sessions"
require "active_support/inflector"

module MyMongoid

  module Document
    extend ActiveSupport::Concern

    include MyMongoid::Attributes
    include MyMongoid::Fields
    include MyMongoid::Sessions

    attr_accessor :is_new_record

    included do
      MyMongoid.register_model(self)
    end

    module ClassMethods
      def is_mongoid_model?
        true
      end

      def create(attr = {})
        e=new(attr)
        e.save
        e
      end

      def instantiate(attr = {})
        e=new(attr)
        e.is_new_record = false
        e
      end

      def find(opts = nil )
        attr = if opts.is_a?(Hash)
                 collection.find(opts).first
               else
                 collection.find({"_id" => opts}).first
               end
        raise MyMongoid::RecordNotFoundError unless attr
        instantiate(attr)
      end

    end

    def initialize(attrs = {})
      @is_new_record = true
      raise ArgumentError unless attrs.is_a?(Hash)
      process_attributes attrs
      yield self if block_given?
    end

    def new_record?
      @is_new_record
    end

    def to_document
      attributes
    end

    def save

      if new_record?
        self._id = BSON::ObjectId.new unless self._id
        self.class.collection.insert(to_document)
      else
        self.class.collection.find({"_id" => self.id}).first.update({"$set" => atomic_updates})
      end
      @is_new_record = false
      clear_changed_attributes
      true
    end

    def changed?
      !changed_attributes.empty?
    end

    def atomic_updates
      if changed?
        d={}
        changed_attributes.each do |k,v|
          d[k]=v[1]
        end
        d
      else
        {}
      end
    end

    def update_document
      updates = atomic_updates

      unless updates.empty?
        update_attributes(updates)
      end
    end

    def update_attributes(attrs={})
      selector = {"_id" => id}
      self.class.collection.find(selector).update( attrs)
    end

    def delete
      self.class.collection.find({"_id" => self.id}).remove
      @deleted = true
    end

    def deleted?
      @deleted ||= false
    end

  end
end
