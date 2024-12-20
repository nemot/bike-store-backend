class CustomBicycle < ApplicationRecord
  has_many :line_items, as: :holder
  has_many :products, through: :line_items

  has_one :frame, -> { joins(:product).merge(Product.for_category("bicycle parts -> frames")) }, as: :holder, class_name: "LineItem"
  has_one :wheels, -> { joins(:product).merge(Product.for_category("bicycle parts -> wheels")) }, as: :holder, class_name: "LineItem"
  has_one :chain, -> { joins(:product).merge(Product.for_category("bicycle parts -> chains")) }, as: :holder, class_name: "LineItem"
  has_one :fork, -> { joins(:product).merge(Product.for_category("bicycle parts -> forks")) }, as: :holder, class_name: "LineItem"
  has_one :pedals, -> { joins(:product).merge(Product.for_category("bicycle parts -> pedals")) }, as: :holder, class_name: "LineItem"
  has_one :seat, -> { joins(:product).merge(Product.for_category("bicycle parts -> seats")) }, as: :holder, class_name: "LineItem"
  has_one :brakes, -> { joins(:product).merge(Product.for_category("bicycle parts -> brakes")) }, as: :holder, class_name: "LineItem"
  has_many :optional_products, as: :holder, class_name: "LineItem"
  has_many :services, -> { joins(:product).merge(Product.for_category("bicycle parts -> services")) }, as: :holder, class_name: "LineItem"


  include RuleSubject
  ruleable_as "bicycle", %w[id frame wheels chain fork pedals brakes optional_products services]
end
