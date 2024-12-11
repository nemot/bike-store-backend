class Product < ApplicationRecord
  acts_as_taggable_on :categories
  has_many :line_items

  scope :for_category, ->(tag_name) { tagged_with(tag_name, on: "categories") }

  include RuleSubject
  ruleable_as "product", %w[name price categories]
end
