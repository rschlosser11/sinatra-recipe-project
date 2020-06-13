class RecipesController < ApplicationController
  get "/recipes" do
    if session[:user_id]
      erb :'recipes/index'
    else
      @error = "You must be logged in to view recipes!"
      erb :homepage
    end
  end

  get "/recipes/new" do
    if session[:user_id]
      erb :'recipes/new'
    else
      @error = "You must be logged in to create a new recipe!"
      erb :homepage
    end
  end

  post "/recipes" do
    @recipe = Recipe.create(params[:recipe])
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
    redirect "/recipes/#{@recipe.id}"
  end

  get "/recipes/:id" do
    if session[:user_id]
      @recipe = Recipe.find(params[:id])

      erb :'recipes/show'
    else
      @error = "You must be logged in to view this recipe!"
      erb :homepage
    end
  end

  delete "/recipes/:id" do
    @recipe = Recipe.find(params[:id])
    if session[:user_id] == @recipe.user.id
      @recipe.delete

      redirect '/recipes'
    else
      @error = "You can only delete a recipe that you've written!"

      erb :"/recipes/show"
    end
  end

  get "/recipes/:id/edit" do
    @recipe = Recipe.find(params[:id])
    if session[:user_id] == @recipe.user.id
      erb :'recipes/edit'
    else
      @error = "You can only edit recipes you've written!"

      erb :"/recipes/show"
    end
  end

  patch "/recipes/:id" do
    @recipe = Recipe.find(params[:id])
    if session[:user_id] == @recipe.user.id
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
    else
      @error = "You can only edit recipes you've written!"

      erb :"/recipes/show"
    end
  end
end
