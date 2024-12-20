module Products
  class UpdateService < ServiceObject
    attribute :product, Types.Instance(Product)
    attribute :params, Types::Strict::Hash

    def call
      product.name = params[:name] if params[:name]
      product.description = params[:description] if params[:description]
      product.price = params[:price] if params[:price]
      product.categories = categories if params[:category_tags]

      product.save ? Success(product) : Failure(product.errors.full_messages)
    end

    private

    def categories
      tags = params[:category_tags].is_a?(String) ? JSON.parse(params[:category_tags]) : params[:category_tags]
      Category.where(id: tags.pluck(:id))
    end
  end
end
