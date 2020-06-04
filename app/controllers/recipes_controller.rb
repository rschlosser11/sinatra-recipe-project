class RecipesController < ApplicationController
  get "/recipes" do
    erb :'recipes/index'
  end

  get "/recipes/new" do
    erb :'recipes/new'
  end

  post "/recipes" do
    @recipe = Recipe.create_with_optional_params(params[:recipe])
    @recipe.user = User.find(session[:user_id])
    ingredients = params[:ingredients].split(/(,|\r\n)/)
    ingredients.each do |ingredient|
      split_ingredient = ingredient.split(' of ')
      ingredient_name = split_ingredient.last.chomp.downcase
      recipe_ingredient = Ingredient.find_by(name: ingredient_name)
      if recipe_ingredient
        recipe_ingredient
      else
        Ingredient.create(name: ingredient_name)
      end
      binding.pry
    end

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
end
