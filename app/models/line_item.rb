class LineItem < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :product, -> { where(source_type: "Product") }, foreign_key: "source_id", optional: true
  belongs_to :holder, polymorphic: true
  include RuleSubject
  ruleable_as "line_item", %w[price quantity product]
end
