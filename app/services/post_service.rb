class PostService
    def initialize(post, url)
        @post = post
        @url = url
    end

    def call
        message = "New post from #{@url}\n#{@post.title}\n#{@post.body}"
        Bot.send_message(ChannelID, message)
    end
end