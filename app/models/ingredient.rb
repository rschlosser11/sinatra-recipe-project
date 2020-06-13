class Ingredient < ActiveRecord::Base
  has_many :recipes_ingredients
  has_many :recipes, through: :recipes_ingredients

  def self.create_from_list(ingredients_list, recipe)
    ingredients = ingredients_list.split(/(,|\r\n)/).delete_if {|string| string == "\r\n" || string == ","}
    ingredients.each do |ingredient|
      split_ingredient = ingredient.split(' of ')
      ingredient_name = split_ingredient.last.chomp.downcase
      recipe_ingredient = Ingredient.find_by(name: ingredient_name)
      ingredient_amount = split_ingredient.first.chomp
      if recipe_ingredient
        RecipesIngredient.create(amount: ingredient_amount, recipe: recipe, ingredient: recipe_ingredient)
      else
        new_ingredient = Ingredient.create(name: ingredient_name)
        RecipesIngredient.create(amount: ingredient_amount, recipe: recipe, ingredient: new_ingredient)
      end
    end
  end
end
