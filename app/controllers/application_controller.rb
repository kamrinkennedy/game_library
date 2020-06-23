require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'top_session'
  end

  get "/" do
    if session[:user_id]
      redirect '/profile'
    else
      erb :index
    end
  end

end
