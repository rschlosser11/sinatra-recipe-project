class Recipe < ActiveRecord::database
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  belongs_to :user
  belongs_to :article
end
