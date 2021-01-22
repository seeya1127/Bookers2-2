class MessagesController < ApplicationController
  def show
    @user = User.find(params[:id])
    #ログインしているユーザーのidが入ったroom_idのみを配列で取得（該当するroom_idが複数でも全て取得）
    rooms = current_user.user_rooms.pluck(:room_id)
    #user_idが@user　且つ　room_idが上で取得したrooms配列の中にある数値のもののみ取得(1個または0個のはずです)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    if user_rooms.nil? #上記で取得できなかった場合の処理
      #新しいroomを作成して保存
      @room = Room.new
      @room.save
      #@room.idと@user.idをUserRoomのカラムに保存(１レコード)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      #@room.idとcurrent_user.idをUserRoomのカラムに保存(１レコード)
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
    else
      #取得している場合は、user_roomsに紐づいているroomテーブルのレコードを@roomに代入
      @room = user_rooms.room
    end
    #if文の中で定義した@roomに紐づくchatsテーブルのレコードを代入
    @messages = @room.messages
    #@room.idを代入したChat.newを用意しておく(message送信時のform用)←筆者の表現が合っているか分かりません、、
    @message = Message.new(room_id: @room.id)
  end

  def create
    @message = current_user.messages.new(message_params)
    @message.save
  end
  
  private
  def message_params
    params.require(:message).permit(:message, :room_id)
  end
end
