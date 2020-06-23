class PlatformController < ApplicationController

    get '/new_platform' do
        erb :'platform/new_platform'
    end

    post '/new_platform' do
        platforms = current_user.platforms
        @error = '*You already have that platform in your collection.*'
        platforms.each do |platform|
            if platform.name.downcase.gsub(' ', '') == params[:platform][:name].downcase.gsub(' ', '')
                return erb :'platform/new_platform'
            end
        end
        platform = Platform.create(params[:platform])
        platform.user = current_user
        platform.save
        redirect '/profile'
    end

    get '/platform/:id' do 
        @platform = Platform.find_by_id(params[:id])
        erb :'platform/show'
    end

    delete '/platform/:id' do
        platform = Platform.find_by_id(params[:id])
        games = platform.games
        games.each {|game| game.destroy}
        platform.destroy
        redirect '/profile'
    end

    helpers do
        def logged_in?
            !!session[:user_id]
        end
    
        def current_user  #memoization
            @current_user ||= User.find_by_id(session[:user_id])
        end
    end
end