class Admin::Channels::UsersController < Admin::BaseController

  def create
    return redirect_to :root unless current_user && current_user.admin?
    @channel = Channel.find_by_permalink(params[:channel_id])
    @user = User.find(params[:user_id])
    @channel.users << @user
    redirect_to admin_users_path
  end

  def destroy
    return redirect_to :root unless current_user && current_user.admin?
    @channel = Channel.find_by_permalink(params[:channel_id])
    @user = User.find(params[:id])
    @channel.users.delete(@user)
    redirect_to admin_users_path
  end

end
