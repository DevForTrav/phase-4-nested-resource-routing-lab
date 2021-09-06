class ItemsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response
  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item
  end

  def create
    item = Item.create(item_params)
    if item
      render json: item, status: :created
    end
  end

  private 

  def find_user
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def record_not_found_response( exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end
end
