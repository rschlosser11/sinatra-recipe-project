class Recipe < ActiveRecord::Base
  has_many :recipes_ingredients
  has_many :ingredients, through: :recipes_ingredients
  belongs_to :user
  belongs_to :article

  def self.create_with_optional_params(params)
    recipe = Recipe.new
    params.each{|k, v| recipe.send("#{k}=", v)}
    recipe.save
    recipe
  end
end
