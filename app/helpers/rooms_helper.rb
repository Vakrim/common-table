module RoomsHelper

  def has_room_token?(room)
    cookies["room_token_#{room.id}"].present?
  end
end
