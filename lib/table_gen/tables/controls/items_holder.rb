module TableGen
  module Tables
    module Controls
      class ItemsHolder
        attr_reader :items

        def initialize
          @items = []
        end

        def add_item(instance)
          @items << instance

          self
        end
      end
    end
  end
end
