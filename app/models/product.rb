class Product < ApplicationRecord
  acts_as_taggable_on :categories
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  has_many :line_items, as: :source

  scope :for_category, ->(tag_name) { tagged_with(tag_name, on: "categories") }

  include RuleSubject
  ruleable_as "product", %w[name price categories]

  def category_tags
    categories.as_json(only: %i[id name])
  end

  def image_thumb_url
    return unless image.attached?

    Rails.application.routes.url_helpers.rails_blob_path(image.variant(:thumb), only_path: true)
  end

  def image_url
    return unless image.attached?

    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) rescue binding.pry
  end
end
