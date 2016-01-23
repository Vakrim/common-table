class RoomsController < ApplicationController
  extend TokenAccess
  authenticate_token! only: [:show], redirect_path: :rooms_path, resource: :find_room
  helper TokenAccess::Helper

  def index
    @rooms = all_rooms
    @new_room = Room.new
  end

  def show
    @room = find_room
    @template_categories = TableItemTemplateStorage.instance.categories
  end

  def access
    @room = find_room
    return redirect_to room_path(@room) if has_cookie_token?(@room)
    return redirect_to rooms_path, alert: 'Password is wrong!' if  @room.private_access? && !@room.authenticate(params[:room][:password])
    set_token!
    redirect_to room_path(@room)
  end

  def create
    @new_room = Room.new(room_params)
    if @new_room.save
      set_token! @new_room
      redirect_to room_path(@new_room), notice: 'Room created!'
    else
      @rooms = all_rooms
      flash.now.alert = @new_room.errors.full_messages.join(', ')
      render :index
    end
  end

  private

  def all_rooms
    Room.order(created_at: :desc)
  end

  def find_room
    Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :password)
  end
end
