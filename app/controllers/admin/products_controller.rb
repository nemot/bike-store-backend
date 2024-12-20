class Admin::ProductsController < ApplicationController
  include Dry::Monads[:result]

  def index
    category = Category.find_by_id(index_params[:category_id])

    render json: Products::AdminIndexResponse.call(
      relation: category.present? ? Product.tagged_with(category.name, on: :categories) : Product.all
    )
  end

  def update
    case Products::UpdateService.call(
      product: Product.find(params.expect(:id)),
      params: params.permit(:name, :description, :category_tags).to_h
    )
    in Success(product)
      render json: Products::AdminIndexResponse.call(relation: Product.where(id: product.id))[0]
    in Failure(error_messages)
      render head: :bad_request, json: { error_messages: }
    end
  end

  def upload_image
    product = Product.find(params[:id])
    product.image.attach(params[:image])
    product.save!
    render head: :ok
  end

  private
  def index_params
    params.permit(:category_id)
  end
end
