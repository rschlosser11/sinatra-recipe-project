class RecipesController < ApplicationController
  get "/recipes" do
    erb :'recipes/index'
  end

  get "/recipes/new" do
    erb :'recipes/new'
  end

  get "/recipes/:id" do
    @recipe = Recipe.find(params[:id])

    erb :'recipes/show'
  end

  get "/recipes/:id/edit" do
    @recipe = Recipe.find(params[:id])

    erb :'recipes/edit'
  end
end
