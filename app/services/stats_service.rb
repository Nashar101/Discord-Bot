require "faraday"
require "dotenv/load"
class StatsService

    def initialize(username)
        @user = username
    end

    def call
        basic_info = get_basic_info
        if basic_info[:success] = false
            Bot.send_message(ChannelID, "An error occured", false)
            return
        end

        rank_info = get_rank_info

        if response.status == 200
            data = JSON.parse(response.body)["data"]
            account_level = data["account_level"]

            # Build the embed object
            embed = Discordrb::Webhooks::Embed.new
            embed.title = "Valorant Account Level"
            embed.description = "Level: #{account_level}"
            embed.color = 0xFF0000 # optional nice red color

            embed.author = Discordrb::Webhooks::EmbedAuthor.new
            embed.author.name = @user
            embed.author.icon_url = data["card"]["small"]

            embed_image = Discordrb::Webhooks::EmbedImage.new
            embed_image.url = data["card"]["wide"]
            embed.image = embed_image

            embed_field = Discordrb::Webhooks::EmbedField.new
            embed_field.name = "Testing"
            embed_field.value = "<div>Hello<div>"
            embed_field.inline = true

            embed.fields = [embed_field]

            # Send the message with embed
            Bot.send_message(ChannelID, nil, false, embed)

            puts response.body
            puts "i went past this"
        end
    end

    def get_basic_info
        api_key = ENV["VALORANT_API_KEY"]

        response = Faraday.get("https://api.henrikdev.xyz/valorant/v1/account/Crop%20Stomper/HMMMM") do |req|
            req.headers['Authorization'] = api_key
        end

        if response.status == 200
            data = JSON.parse(response.body)["data"]
            return { success: true, account_level: data["account_level"], small_card: data["card"]["small"], wide_card: data["card"]["wide"] }
        end
        { success: false }
    end

    def get_rank_info
        api_key = ENV["VALORANT_API_KEY"]

        response = Faraday.get("https://api.henrikdev.xyz/valorant/v3/mmr/eu/pc/Crop%20Stomper/HMMMM") do |req|
            req.headers['Authorization'] = api_key
        end

        if response.status == 200
            data = JSON.parse(response.body)["data"]
            return { success: true, current_rank: data["account_level"], small_card: data["card"]["small"], wide_card: data["card"]["wide"] }
        end
        { success: false }
    end
end