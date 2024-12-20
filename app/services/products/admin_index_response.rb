module Products
  class AdminIndexResponse < ResponseObject
    def call
      products.as_json(
        only: %i[id name price description],
        methods: %i[image_url image_thumb_url category_tags]
      )
    end

    private
    def products
      relation.includes(image_attachment: :blob)
              .includes(:categories)
              .order("updated_at DESC")
    end
  end
end
