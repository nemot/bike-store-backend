class Product < ApplicationRecord
  acts_as_taggable_on :categories
end
