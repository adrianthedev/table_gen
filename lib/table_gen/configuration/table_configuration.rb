module TableGen
  class Configuration
    module TableConfiguration
      def table_controls_placement=(val)
        @table_controls_placement_instance = val
      end

      def table_controls_placement
        @table_controls_placement_instance || :right
      end

      def table_controls_on_the_left?
        table_controls_placement == :left
      end

      def table_controls_on_the_right?
        table_controls_placement == :right
      end
    end
  end
end
