require 'pry'

class GameController < ApplicationController

    get '/game/new' do
        if !logged_in?
            redirect '/login'
        end
        @platform = Platform.find_by_id(params[:id])
        erb :'game/new'
    end

    post '/game/new' do
        if !logged_in?
            redirect '/login'
        end
        platform = Platform.find_by_id(params[:game][:platform])
        games = platform.games
        games.each do |game|
            if game.name.downcase.gsub(' ', '') == params[:game][:name].downcase.gsub(' ', '')
                @error = '*You already have that game in your collection.*'
                return erb :'game/new'
            end
        end
        game = Game.new(name: params[:game][:name], platform: platform, user: current_user)
        game.players = params[:game][:players]
        game.description = params[:game][:description]
        game.save
        redirect "/game/#{game.id}"
    end

    get '/game' do
        if !logged_in?
            redirect '/login'
        end
        erb :'game/index'
    end

    get '/game/:id' do
        if !logged_in?
            redirect '/login'
        end
        @game = Game.find_by_id(params[:id])
        if @game
            erb :'game/show'
        else
            redirect '/profile'
        end
    end
    
    delete '/game/:id' do
        game = Game.find_by_id(params[:id])
        if !current_user.id == game.user.id
            redirect '/profile'
        end
        platform = game.platform
        game.destroy
        redirect "/platform/#{platform.id}"
    end

    get '/game/:id/edit' do
        if !logged_in?
            redirect '/login'
        end
        @game = Game.find_by_id(params[:id])
        
        if @game.user.id == current_user.id
            @platforms = current_user.platforms
            erb :'game/edit'
        else
            redirect '/profile'
        end
    end

    patch '/game/:id/edit' do
        if !logged_in?
            redirect '/login'
        end
        game = Game.find_by_id(params[:id])
        if game.user.id == current_user.id
            game.name = params[:game][:name]
            game.platform = Platform.find_by_id(params[:game][:platform])
            game.players = params[:game][:players]
            game.description = params[:game][:description]
            game.save
            redirect "/game/#{game.id}"
        else
            redirect '/profile'
        end
    end

end