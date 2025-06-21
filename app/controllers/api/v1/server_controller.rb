# frozen_string_literal: true
class Api::V1::ServerController < ApplicationController

  #These are all methods pertaining to the Terraria Calamity Mod.
  # The requests are Made by a Terraria Mod that listens player events on the server, hopefully the name of
  # the methods are self explanatory.

  #Player Based events
  def player_connected
    $redis.incr("terraria_active_player_count")
    send_player_count_message(params[:player], "connected")
    render json: {success: true }, status: 200
  end

  def player_disconnected
    $redis.decr("terraria_active_player_count")
    send_player_count_message(params[:player], "disconnected")
    render json: {success: true }, status: 200
  end

  def player_died
    Bot.send_message(ServerChannelID, "#{params[:cause]}. Total number of deaths: 1")
  end

  #Misc commands
  def send_player_count_message(player_name, status)
    if $redis.get("terraria_active_player_count") == "1"
      #Bot.user(304225991612432384).display_name
      Bot.send_message(ServerChannelID, "#{player_name} has #{status}.  There is now #{$redis.get("terraria_active_player_count")} player online.")
    else
      Bot.send_message(ServerChannelID, "#{player_name} has #{status}.  There are now #{$redis.get("terraria_active_player_count")} players online.")
    end
  end
  #Bot.user(304225991612432384).mention (this line above creates the shit down there, now i need to find a way to keep this link somewhere)
  #Bot.send_message(ChannelID, "<@#{304225991612432384}> testing")
  def verify_account_linking
    if $redis.get(params[:verification_value]).nil?
      render json: {success: false}, status: 498
    else
      render json: {success: true }, status: 200
      user = User.find($redis.get(params[:verification_value]))
      user.steam_id = params[:steam_id]
      user.save!
      Bot.send_message(ServerChannelID, "#{Bot.user($redis.get(params[:verification_value])).mention} your account has now being linked, some events that occur to you in the server will be shown here.")
    end
  end

  def hello
    Bot.send_message(ChannelID, "hi")
    render json: {love: 1, test: "Hello"}, status: 200
  end
end
