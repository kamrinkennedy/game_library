class PlatformController < ApplicationController

    get '/platform/new' do
        if !logged_in?
            redirect '/login'
        else
            erb :'platform/new'
        end
    end

    post '/platform/new' do
        platforms = current_user.platforms
        @error = '*You already have that platform in your collection.*'
        platforms.each do |platform|
            if platform.name.downcase.gsub(' ', '') == params[:platform][:name].downcase.gsub(' ', '')
                return erb :'/platform/new'
            end
        end
        platform = Platform.create(params[:platform])
        platform.user = current_user
        platform.save
        redirect '/profile'
    end

    get '/platform/:id' do 
        @platform = Platform.find_by_id(params[:id])
        if @platform
            erb :'platform/show'
        else
            redirect '/profile'
        end
    end

    delete '/platform/:id' do
        platform = Platform.find_by_id(params[:id])
        if current_user.id == platform.user.id
            games = platform.games
            games.each {|game| game.destroy}
            platform.destroy
        end
        redirect '/profile'
    end

end