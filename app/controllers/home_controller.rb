class HomeController < ApplicationController
  before_action :authenticate_user!

  def profile
    @user = current_user
  end

  def tweets
    @tweets = current_user.tweets.order('created_at DESC').page(params[:page]).per(50)
  end
end
