# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class TableChannel < ApplicationCable::Channel
  include TableItemHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def subscribed
    room = Room.find_by_token params[:room_token]
    stream_from "table_#{room.token}" if room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update(data)
    table_item = TableItem.find(data['table_item_id'])
    table_item.update_from_css(data['style'])
    broadcast_msg = { action: data['action'], table_item_id: table_item.id, style: style_hash_for_table_item(table_item) }
    ActionCable.server.broadcast "table_#{params[:room_token]}", broadcast_msg
  end

  def create(data)
    template = TableItemTemplate.find(data['template_id'])
    room = Room.find_by_token params[:room_token]
    table_item = TableItem.create_from_template!(template, room)

    broadcast_msg = { action: data['action'], html: render_table_item(table_item) }
    ActionCable.server.broadcast "table_#{params[:room_token]}", broadcast_msg
  end
end
