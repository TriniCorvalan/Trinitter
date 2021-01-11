class ApiController < ActionController::API
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
end
