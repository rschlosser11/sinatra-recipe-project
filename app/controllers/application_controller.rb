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

  post "/login" do
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/recipes'
    else
      redirect '/login'
    end
  end

end
