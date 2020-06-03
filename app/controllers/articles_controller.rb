class ArticlesController < ApplicationController
  get "/articles" do
    erb :'articles/index'
  end

  get "/articles/new" do
    erb :'articles/new'
  end

  get "/articles/:id" do
    @article = Article.find(params[:id])

    erb :'articles/show'
  end

  delete "/articles/:id" do
    @article = Article.find(params[:id])
    @article.delete
    
    redirect '/articles'
  end

  get "/articles/:id/edit" do
    @article = Article.find(params[:id])

    erb :'articles/edit'
  end
end
