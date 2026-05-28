class FoodSearchController < ApplicationController
  def index
    query = params[:query].to_s.strip
    results = query.length >= 2 ? UsdaFoodService.search(query) : []
    render json: results
  end
end
