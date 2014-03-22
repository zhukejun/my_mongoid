module MyMongoid
  module Sessions
    extend ActiveSupport::Concern

    module ClassMethods
      def collection_name
        name.tableize
      end

      def collection
        MyMongoid.session[collection_name]
      end
    end
  end
end
