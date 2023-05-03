module TableGen
  module Tables
    module Controls
      class Action < BaseControl
        attr_reader :klass

        def initialize(klass, model: nil, table: nil, **args)
          super(**args)

          @klass = klass
          @table = table
          @model = model
        end

        def action
          @instance ||= @klass.new(model: @model, table: @table)
        end

        def path
          TableGen::Services::URIService.parse(@table.record_path).append_paths("actions", action.param_id).to_s
        end

        def label
          @args[:label] || action.action_name
        end
      end
    end
  end
end
