class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id]) # 指定のユーザーを見つける
    @books = @user.books.reverse_order # そのユーザーの投稿を古い順で並べる
    @book = Book.new # 新規投稿用の空のインスタンス
    @favorite_books = @user.favorites
    @user_followers = @user.followers
    @user_follows = @user.follows
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(User_params)
    @user = current_user.id
    if @user.save
      NotificationMailer.send_signup_email(@user).deliver
      flash[:notice] = 'You have updated user successfully.'
      redirect_to user_path(@user.id)
    else
      render :index
    end
  end

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    redirect_to user_path(current_user) if @user != current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: 'You have updated user successfully.'
    else
      render :edit
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.follows
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image,:postcode, :prefecture_name, :address_city, :address_street)
  end
end
