class UserController < ApplicationController

    get '/signup' do
        if session[:user_id]
            session.clear
        end
        erb :'user/new'
    end

    post '/signup' do
        if params[:user].values.any? { |v| v.blank? }
            @error = "*Both fields are required for Sign Up*"
            erb :'user/new'
        else
            user = User.create(params[:user])
            session[:user_id] = user.id
            redirect to '/profile'
        end
    end

    get '/profile' do
        @user = User.find_by_id(session[:user_id])
        if @user
            erb :'user/profile'
        else
            redirect '/login'
        end
    end

    get '/login' do
        erb :'user/login'
    end

    post '/login' do
        user = User.find_by_username(params[:user][:username])
        if user && user.authenticate(params[:user][:password])
            session[:user_id] = user.id
            redirect '/profile'
        else
            @error = "*Invalid information. Please try again*"
            erb :'user/login'
        end
    end

    get '/logout' do
        session.clear
        redirect '/login'
    end

end