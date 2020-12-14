class TweetsController < ApplicationController
  before_action :set_tweet, only: [:like, :dislike, :show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  def like
    Like.create(user_id: current_user.id, tweet_id: @tweet.id)
    redirect_to root_path
  end

  def dislike
    Like.find_by(user_id: current_user.id, tweet_id: @tweet.id).destroy
    redirect_to tweet_path(@tweet)
  end

  def index
    @tweets = Tweet.order('created_at DESC').page(params[:page]).per(50)
  end

  def show
   
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
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:content, :user_id)
  end
end
