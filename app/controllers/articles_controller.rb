class ArticlesController < ApplicationController

  get "/articles" do
    if session[:user_id]
      erb :'articles/index'
    else
      @error = "You can only see articles if you're logged in!"
      erb :homepage
    end
  end

  get "/articles/new" do
    if session[:user_id]
      erb :'articles/new'
    else
      @error = "You can only write new articles if you're logged in!"
      erb :homepage
    end
  end

  post "/articles" do
    @article = Article.new(params)
    @article.user = User.find(session[:user_id])
    @article.save
    redirect "/articles/#{@article.id}"
  end

  get "/articles/:id" do
    if session[:user_id]
      @article = Article.find(params[:id])

      erb :'articles/show'
    else
      @error = "You must be logged in to see this article!"
      erb :homepage
    end
  end

  delete "/articles/:id" do
    @article = Article.find(params[:id])
    if session[:user_id] == @article.user.id
      @article.delete
      redirect '/articles'
    else
      erb :'/articles/:id'
    end
  end

  get "/articles/:id/edit" do
    @article = Article.find(params[:id])
    if session[:user_id] == @article.user.id
      erb :'articles/edit'
    else
      @error = "You can only edit articles you wrote!"
      erb :"/articles/show"
    end
  end

  patch "/articles/:id" do
    @article = Article.find(params[:id])
    if session[:user_id] == @article.user.id
      @article.update(params[:article])
      redirect "/articles/#{@article.id}"
    else
      redirect "/articles/#{@article.id}"
    end
  end
end
