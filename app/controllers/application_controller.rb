require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password"
  end

  get "/" do
    erb :welcome
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.create(params)
    session[:user_id] = user.id
    if user.id
      redirect '/recipes'
    else
      redirect '/signup'
    end
  end

  get "/login" do
    erb :login
  end


end
