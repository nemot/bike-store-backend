class CustomBicycle < ApplicationRecord
  has_many :custom_bicycle_products
  has_many :products, through: :custom_bicycle_products
end
