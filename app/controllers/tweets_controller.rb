class TweetsController < ApplicationController
  before_action :set_tweet, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]

  def like
    Like.create(user_id: current_user.id, tweet_id: @tweet.id)
    redirect_to root_path
  end

  def dislike
    Like.find_by(user_id: current_user.id, tweet_id: @tweet.id).destroy
    redirect_to root_path
  end

  def retweet
    @retweet = Tweet.create(user_id: current_user.id, tweet_id: @tweet.id, content: @tweet.content)

    respond_to do |format|
      if @retweet.save
        format.html { redirect_to @retweet, notice: 'Tweet was successfully created.' }
      else
        format.html { render :show }
      end
    end
  end

  def index
    @tweets = Tweet.order('created_at DESC').page(params[:page]).per(50)
  end

  def show
    @retweet = Tweet.find_by(id: @tweet.tweet_id)
  end

  def new
    @tweet = Tweet.new
  end

  def edit
  end

  def create
    @tweet = Tweet.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to root_path, notice: 'Tweet was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:content, :user_id, :tweet_id)
  end
end
