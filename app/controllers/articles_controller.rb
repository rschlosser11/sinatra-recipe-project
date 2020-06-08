class ArticlesController < ApplicationController
# SHOW all articles
  get "/articles" do
    erb :'articles/index'
  end
# SHOW form to create new article
  get "/articles/new" do
    erb :'articles/new'
  end
# CREATE new article
  post "/articles" do
    @article = Article.create(params)
    @article.user = User.find(session[:user_id])

    redirect "/articles/#{@article.id}"
  end
# SHOW individual article
  get "/articles/:id" do
    @article = Article.find(params[:id])

    erb :'articles/show'
  end
# DELETE individual article
  delete "/articles/:id" do
    @article = Article.find(params[:id])
    if session[:user_id] == @article.user.id
      @article.delete
      redirect '/articles'
    else
      erb :'/articles/:id'
  end
# SHOW edit form for individual article
  get "/articles/:id/edit" do
    @article = Article.find(params[:id])

    erb :'articles/edit'
  end
end
