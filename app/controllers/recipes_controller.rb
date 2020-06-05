class RecipesController < ApplicationController
  get "/recipes" do
    erb :'recipes/index'
  end

  get "/recipes/new" do
    erb :'recipes/new'
  end

  post "/recipes" do
    @recipe = Recipe.create_with_optional_params(params[:recipe])
    @recipe.update(user: User.find(session[:user_id]), directions: params[:directions])
    ingredients = params[:ingredients].split(/(,|\r\n)/).delete_if {|string| string == "\r\n" || string == ","}
    ingredients.each do |ingredient|
      split_ingredient = ingredient.split(' of ')
      ingredient_name = split_ingredient.last.chomp.downcase
      recipe_ingredient = Ingredient.find_by(name: ingredient_name)
      ingredient_amount = split_ingredient.first.chomp
      if recipe_ingredient
        RecipesIngredient.create(amount: ingredient_amount, recipe: @recipe, ingredient: recipe_ingredient)
      else
        new_ingredient = Ingredient.create(name: ingredient_name)
        RecipesIngredient.create(amount: ingredient_amount, recipe: @recipe, ingredient: new_ingredient)
      end
    end
    binding.pry
    redirect "/recipes/#{@recipe.id}"
  end

  get "/recipes/:id" do
    @recipe = Recipe.find(params[:id])

    erb :'recipes/show'
  end

  delete "/recipes/:id" do
    @recipe = Recipe.find(params[:id])
    @recipe.delete

    redirect '/recipes'
  end

  get "/recipes/:id/edit" do
    @recipe = Recipe.find(params[:id])

    erb :'recipes/edit'
  end

  patch "/recipes/:id" do
    @recipe = Recipe.find(params[:id])
    ingredients = params[:ingredients].split(/(,|\r\n)/).delete_if {|string| string == "\r\n" || string == ","}
    RecipesIngredient.all.where(recipe_id: @recipe.id).map{|ingredient| ingredient.delete}
    ingredients.each do |ingredient|
      split_ingredient = ingredient.split(' of ')
      ingredient_name = split_ingredient.last.chomp.downcase
      recipe_ingredient = Ingredient.find_by(name: ingredient_name)
      ingredient_amount = split_ingredient.first.chomp
      if recipe_ingredient
        RecipesIngredient.create(amount: ingredient_amount, recipe: @recipe, ingredient:recipe_ingredient)
      else
        new_ingredient = Ingredient.create(name: ingredient_name)
        RecipesIngredient.create(amount: ingredient_amount, recipe: @recipe, ingredient: new_ingredient)
      end
    end
    @recipe.update(params[:recipe])
    @recipe.update(directions: params[:directions])
    redirect "/recipes/#{@recipe.id}"
  end
end
