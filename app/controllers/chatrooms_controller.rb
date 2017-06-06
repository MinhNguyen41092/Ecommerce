class ChatroomsController < ApplicationController
  before_action :authorize_chatroom, only: :show
  before_action :verify_admin, only: [:index, :destroy]

  def index
    @chatrooms = Chatroom.newest.page(params[:page]).
      per Settings.items_per_pages
  end

  def new
    @chatroom = Chatroom.new
  end

  def create
    @chatroom = Chatroom.new chatroom_params
    if @chatroom.save
      flash[:success] = t "chat.created"
      redirect_to chatroom_path @chatroom
    else
      render :new
    end
  end

  def show
    @message = Message.new
  end

  def destroy
    @chatroom = Chatroom.find_by(name: params[:name])
    if @chatroom.destroy
      flash[:success] = "Chatroom has been deleted"
    else
      flash[:danger] = "Couldn't delete chatroom"
    end
    redirect_to chatrooms_path
  end

  private

  def chatroom_params
    params.require(:chatroom).permit :topic, :user_id
  end

  def authorize_chatroom
    if @chatroom = Chatroom.find_by(name: params[:name])
      if (@chatroom.user_id == current_user.id) || current_user.is_admin
        return @chatroom
      else
        flash[:danger] = "You can not access this chatroom"
        redirect_to :back
      end
    else
      flash[:danger] = "There is no such chatroom"
      redirect_to :back
    end
  end
end
