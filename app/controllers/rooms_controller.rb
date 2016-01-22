class RoomsController < ApplicationController

  def index
    @rooms = Room.order(created_at: :desc)
    @new_room = Room.new
  end

  def show
    @room = Room.find(params[:id])
    redirect_to rooms_path, alert: 'Password is wrong' if @room.private_access? && cookies["room_token_#{@room.id}"] != Digest::SHA1.hexdigest("#{@room.token} #{cookies[:user_room_token]}")
  end

  def access
    @room = Room.find(params[:id])
    return redirect_to room_path(@room) if @room.public_access? || cookies["room_token_#{@room.id}"].present?
    return redirect_to rooms_path, alert: 'Password is wrong' unless @room.authenticate(params[:room][:password])
    cookies.permanent[:user_room_token] ||= SecureRandom.base58(24)
    cookies.permanent["room_token_#{@room.id}"] = Digest::SHA1.hexdigest("#{@room.token} #{cookies[:user_room_token]}")
    redirect_to room_path(@room)
  end

  def create
    @new_room = Room.new(room_params)
    if @new_room.save
      redirect_to room_path(@new_room), notice: 'Room created!'
    else
      @rooms = Room.order(created_at: :desc)
      flash.now.alert = @new_room.errors.full_messages.join(', ')
      render :index
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :password)
  end
end
