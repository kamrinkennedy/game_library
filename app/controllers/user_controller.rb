class UserController < ApplicationController

    get '/signup' do
        if logged_in?
            redirect '/profile'
        end
        erb :'user/new'
    end

    post '/signup' do
        
        User.all.each do |user|
            if user.username.downcase.gsub(' ', '') == params[:user][:username].downcase.gsub(' ', '')
                @error = '*That username is already in use*'
                return erb :'user/new'
            end
        end
        user = User.create(params[:user])
        session[:user_id] = user.id
        redirect to '/profile'
    end

    get '/profile' do
        if !logged_in?
            redirect '/login'
        end
        @user = User.find_by_id(session[:user_id])
        @platforms = @user.platforms
        if @user
            erb :'user/profile'
        else
            redirect '/login'
        end
    end

    get '/login' do
        if logged_in?
            redirect '/profile'
        end
        erb :'user/login'
    end

    post '/login' do
        user = User.find_by_username(params[:user][:username])
        if user && user.authenticate(params[:user][:password])
            session[:user_id] = user.id
            redirect '/profile'
        else
            @error = "*Invalid Username/Password*"
            erb :'user/login'
        end
    end

    get '/logout' do
        session.clear
        redirect '/'
    end

    get '/user' do
        @users = User.all
        erb :'user/index'
    end

    get '/user/:id' do
        @user = User.find_by_id(params[:id])
        if @user
            erb :'user/show'
        else
            redirect '/profile'
        end
    end

end