require 'pry'

class GameController < ApplicationController

    get '/new_game' do
        if !logged_in?
            redirect '/login'
        end
        @platform = Platform.find_by_id(params[:id])
        erb :'game/new_game'
    end

    post '/new_game' do
        if !logged_in?
            redirect '/login'
        end
        
        platform = Platform.find_by_id(params[:game][:platform])
        games = platform.games
        @error = '*You already have that game in your collection.*'
        games.each do |game|
            if game.name.downcase.gsub(' ', '') == params[:game][:name].downcase.gsub(' ', '')
                return erb :'game/new_game'
            end
        end
        game = Game.new(name: params[:game][:name])
        game.platform = platform
        game.user = current_user
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

    helpers do
        def logged_in?
            !!session[:user_id]
        end
    
        def current_user  #memoization
            @current_user ||= User.find_by_id(session[:user_id])
        end
    end

end