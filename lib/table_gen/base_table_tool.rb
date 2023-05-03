module TableGen
  class BaseTableTool
    include TableGen::Concerns::IsTableItem

    class_attribute :name
    class_attribute :partial
    class_attribute :item_type, default: :tool

    attr_accessor :params, :table

    def hydrate
      self
    end

    def partial
      return self.class.partial if self.class.partial.present?

      "table_gen/table_tools/#{self.class.to_s.underscore}"
    end
  end
end
