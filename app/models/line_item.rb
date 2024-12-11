class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :holder, polymorphic: true
  include RuleSubject
  ruleable_as "line_item", %w[price quantity product]
end
