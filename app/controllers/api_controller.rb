
  class ApiController < ActionController::API
    # include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :authenticate_user!, only: [:create]

    def news
      @tweets = Tweet.order('created_at DESC').limit(50)
      respuesta = []
      hash = {}
      @tweets.each do |tweet|
        hash = {
          id: tweet.id,
          content: tweet.content,
          user_id: tweet.user.id,
          likes_count: tweet.likes_count,
          retweets_count: tweet.rt_count,
          retweeted_from: tweet.tweet_id
        }
        respuesta.push(hash)
      end
      render json: respuesta
    end

    def by_date
      @tweets = Tweet.where(created_at: params[:date1].to_date...params[:date2].to_date).order('created_at ASC')

        respuesta = []
        hash = {}
        @tweets.each do |tweet|
          hash = {
            id: tweet.id,
            content: tweet.content,
            user_id: tweet.user.id,
            likes_count: tweet.likes_count,
            retweets_count: tweet.rt_count,
            retweeted_from: tweet.tweet_id
          }
        respuesta.push(hash)
      end
      render json: respuesta
    end

    def create
      @tweet = Tweet.new(tweet_params)

      if @tweet.save
        render json: @tweet, status: :created, location: @tweet
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    private
    
    def tweet_params
      params.require(:tweet).permit(:content, :user_id)
    end

  end
