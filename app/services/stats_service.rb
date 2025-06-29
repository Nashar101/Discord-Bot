require "faraday"
require "dotenv/load"
class StatsService
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::AssetUrlHelper
    include ActionView::Helpers::AssetTagHelper

    def initialize(user)
        @user = User.find(user.id)
    end

    def call
        basic_info = get_basic_info
        return Bot.send_message(ChannelID, "An error occured", false) if basic_info[:success] == false

        rank_info = get_rank_info
        return Bot.send_message(ChannelID, "An error occured", false) if rank_info[:success] == false

            # Build the embed object
        embed = Discordrb::Webhooks::Embed.new
        embed.title = "Crop Stomper's Valorant Stats"
        embed.description = "Level: #{basic_info[:account_level]} (Fucking no life)"
        embed.color = 0xFF0000 # optional nice red color

        embed.author = Discordrb::Webhooks::EmbedAuthor.new
        embed.author.name = @user.username
        embed.author.icon_url = @user.avatar_url

        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new
        embed.thumbnail.url = RankHelper.rank(rank_info[:current_rank]["name"])

        embed_image = Discordrb::Webhooks::EmbedImage.new
        embed_image.url = basic_info[:wide_card]
        embed.image = embed_image

        curr_rank_field = generate_embed_field("Current Rank", rank_info[:current_rank]["name"], true)
        spacing = generate_embed_field("\u200B", "", false)
        small_spacing = generate_embed_field("", "", false)
        peak_rank_field = generate_embed_field("Peak Rank", rank_info[:peak_rank]["name"], false)
        rr_field = generate_embed_field("RR", rank_info[:rr], true)

        kda = get_kda
        puts kda
        kd_field = generate_embed_field("KD", kda[:kd], true)
        kda_field = generate_embed_field("KDA", kda[:kda], true)

        embed.fields = [peak_rank_field, spacing, curr_rank_field, rr_field, small_spacing, kd_field, kda_field]

        embed.footer = Discordrb::Webhooks::EmbedFooter.new
        embed.footer.icon_url = basic_info[:wide_card]
        embed.footer.text = "Hello"
            # Send the message with embed
        Bot.send_message(ChannelID, nil, false, embed)
    end

    def get_basic_info
        api_key = ENV["VALORANT_API_KEY"]

        response = Faraday.get("https://api.henrikdev.xyz/valorant/v2/by-puuid/account/#{@user.valorant_id}") do |req|
            req.headers['Authorization'] = api_key
        end

        if response.status == 200
            data = JSON.parse(response.body)["data"]
            puts data
            return { success: true, account_level: data["account_level"], small_card: data["card"]["small"], wide_card: data["card"]["wide"] }
        end


        { success: false }
    end

    def get_rank_info
        api_key = ENV["VALORANT_API_KEY"]

        response = Faraday.get("https://api.henrikdev.xyz/valorant/v3/by-puuid/mmr/eu/pc/#{@user.valorant_id}") do |req|
            req.headers['Authorization'] = api_key
        end

        if response.status == 200
            data = JSON.parse(response.body)["data"]
            return { success: true, current_rank: data["current"]["tier"], peak_rank: data["peak"]["tier"], rr: data["current"]["rr"] }
        end

        { success: false }
    end

    def get_kda
        api_key = ENV["VALORANT_API_KEY"]

        #this takes last ten matches you checked this shit Gilead by compare tracker.gg stats

        response = Faraday.get("https://api.henrikdev.xyz/valorant/v4/by-puuid/matches/eu/pc/#{@user.valorant_id}?mode=competitive&size=1") do |req|
            req.headers['Authorization'] = api_key
            req.params['size'] = 20
        end

        if response.status == 200
            data = JSON.parse(response.body)["data"]
            kills = 0
            assists = 0
            deaths = 0
            data.each do |match|
                match["players"].each do |player|
                    if player["name"] == "Crop Stomper" && player["tag"] == "HMMMM"
                        kills += player["stats"]["kills"].to_i
                        assists += player["stats"]["deaths"].to_i
                        deaths += player["stats"]["assists"].to_i
                    end
                end
            end

            return { success: true, kda: ((kills+assists)/deaths.to_f).round(2).to_s, kd: ((kills)/deaths.to_f).round(2).to_s }
        end

        { success: false }
    end

    def generate_embed_field(name, value, inline)
        field = Discordrb::Webhooks::EmbedField.new
        field.name = name
        field.value = value
        field.inline = inline
        field
    end
end