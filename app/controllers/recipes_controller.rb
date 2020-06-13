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
    Ingredient.create_from_list(params[:ingredients], @recipe)
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
      Ingredient.create_from_list(params[:ingredients], @recipe)
      @recipe.update(params[:recipe])
      @recipe.update(directions: params[:directions])
      redirect "/recipes/#{@recipe.id}"
    else
      @error = "You can only edit recipes you've written!"

      erb :"/recipes/show"
    end
  end
end
