# frozen_string_literal: true
class Api::V1::ServerController < ApplicationController

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

  def send_player_count_message(player_name, status)
    if $redis.get("terraria_active_player_count") == "1"
      Bot.send_message(ServerChannelID, "#{player_name} has #{status}.  There is now #{$redis.get("terraria_active_player_count")} player online.")
    else
      Bot.send_message(ServerChannelID, "#{player_name} has #{status}.  There are now #{$redis.get("terraria_active_player_count")} players online.")
    end
  end

  def player_died

  end

  def hello
    Bot.send_message(ChannelID, "hi")
    render json: {love: 1, test: "Hello"}, status: 200
  end

end
