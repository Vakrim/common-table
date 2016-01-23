# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class TableChannel < ApplicationCable::Channel
  include TableItemHelper
  include ActionView::Helpers::AssetTagHelper

  def subscribed
    room = Room.find_by_token params[:room_token]
    stream_from "table_#{room.token}" if room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update(data)
    ActionCable.server.broadcast "table_#{params[:room_token]}", data
  end

  def create(data)
    template = TableItemTemplate.find(data['template_id'])
    room = Room.find_by_token params[:room_token]
    table_item = TableItem.create_from_template!(template, room)

    html = render_table_item(table_item)
    ActionCable.server.broadcast "table_#{params[:room_token]}", { action: data['action'], html: html }
  end
end
