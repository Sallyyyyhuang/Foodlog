require "net/http"
require "json"
require "uri"

class UsdaFoodService
  API_KEY = ENV.fetch("USDA_API_KEY", "DEMO_KEY")
  BASE_URL = "https://api.nal.usda.gov/fdc/v1/foods/search"

  def self.search(query)
    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form(query: query, pageSize: 8, api_key: API_KEY)

    response = Net::HTTP.get_response(uri)
    return [] unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    foods = data["foods"] || []

    foods.map do |food|
      nutrients = index_nutrients(food["foodNutrients"] || [])
      {
        name:          food["description"],
        calories:      nutrient_value(nutrients, "Energy"),
        proteins:      nutrient_value(nutrients, "Protein"),
        carbohydrates: nutrient_value(nutrients, "Carbohydrate, by difference"),
        fats:          nutrient_value(nutrients, "Total lipid (fat)")
      }
    end
  rescue StandardError
    []
  end

  private_class_method def self.index_nutrients(list)
    list.each_with_object({}) { |n, h| h[n["nutrientName"]] = n["value"] }
  end

  private_class_method def self.nutrient_value(index, name)
    index[name].to_f.round
  end
end
