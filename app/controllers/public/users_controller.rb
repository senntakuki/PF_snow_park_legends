class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user, only: [:edit, :update, :destroy]
  before_action :ensure_guest_user, only: [:edit]
  before_action :set_user, only: [:favorites]

   def show
      @user = User.find(params[:id])
      @tweets = @user.tweets
   end

   def index
      @users = User.all
   end

   def edit
      @user = User.find(params[:id])
   end

   def update
     @user = User.find(params[:id])
     @user.update(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render :edit
    end
   end

    def is_deleted
        @user = current_user
     if @user.update(is_deleted: true)
        sign_out_and_redirect(current_user)
     else
        render "unsubscribe"
     end
    end

    def remove
        @user = current_user
     if @user.update(is_deleted: true)
       sign_out_and_redirect(current_user)
     else
       render "unsubscribe"
     end
    end

   private

    def ensure_guest_user
       @user = User.find(params[:id])
      if @user.name == "ゲストユーザー"
       redirect_to user_path(current_user) , notice: 'ゲストユーザーは編集できません。'
      end
    end

    def ensure_user
       @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
    end


   def user_params
     params.require(:user).permit(:name, :profile_image, :introduction, :is_deleted)
   end


end
