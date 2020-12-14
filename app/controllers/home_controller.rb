class HomeController < ApplicationController
  def profile
    @user = current_user
  end

  def tweets
    @tweets = current_user.tweets
  end
end
