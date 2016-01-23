# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class TableChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find_by_token params[:room_token]
    stream_from "table_#{room.token}" if room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def move(data)
    ActionCable.server.broadcast "table_#{params[:room_token]}", data
  end
end
