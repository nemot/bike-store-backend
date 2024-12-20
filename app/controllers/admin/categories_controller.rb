class Admin::CategoriesController < ApplicationController
  def index
    render json: Categories::IndexResponse.call
  end

  def update
    result = Categories::UpdateService.call(
      category_tag: Category.find(params[:id]),
      new_name: params.expect(:tag)
    )

    render head: result.success? ? :ok : :internal_server_error
  end

  private
  def update_params
  end
end
