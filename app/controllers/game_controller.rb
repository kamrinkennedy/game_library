require 'pry'

class GameController < ApplicationController

    get '/new_game' do
        @platform = Platform.find_by_id(params[:id])
        erb :'game/new_game'
    end

    post '/new_game' do
        game = Game.create(params[:game])
        game.platform = Platform.find_by_id(params[:id])
        game.user = current_user
        game.save
        redirect "/platform/#{params[:id]}"
    end

    get '/game/:id' do
        @game = Game.find_by_id(params[:id])
        erb :'game/show'
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