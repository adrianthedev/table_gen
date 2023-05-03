module TableGen
  module Tables
    module Controls
      class BaseControl
        def initialize(**args)
          @args = args
        end

        def label
          @args[:label] || @label
        end

        def title
          @args[:title]
        end

        def color
          @args[:color] || :gray
        end

        def style
          @args[:style] || :text
        end

        def icon
          @args[:icon] || nil
        end

        def edit_button?
          is_a? TableGen::Tables::Controls::EditButton
        end

        def delete_button?
          is_a? TableGen::Tables::Controls::DeleteButton
        end

        def actions_list?
          is_a? TableGen::Tables::Controls::ActionsList
        end

        def link_to?
          is_a? TableGen::Tables::Controls::LinkTo
        end

        def action?
          is_a? TableGen::Tables::Controls::Action
        end
      end
    end
  end
end
