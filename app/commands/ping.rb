require 'erb'

def get_account(name, tag)
  api_key = ENV["VALORANT_API_KEY"]
  response = Faraday.get("https://api.henrikdev.xyz/valorant/v2/account/#{ERB::Util.url_encode(name)}/#{tag}") do |req|
    req.headers['Authorization'] = api_key
  end

  if response.status == 200
    cache_status = response.headers['x-cache-status']
    ttl = response.headers['x-cache-ttl']
    puts "Cache Status: #{cache_status}, TTL: #{ttl}"

    data = JSON.parse(response.body)["data"]
    puts data
    return { success: true, id: data["puuid"], title: data["title"] }
  end

  { success: false }
end

def get_title(uuid)
  response = Faraday.get("https://valorant-api.com/v1/playertitles")
  if response.status == 200
    data = JSON.parse(response.body)["data"]
    data.each do |title|
      if title["uuid"] == uuid
        return title["titleText"]
      end
    end
  end
  ""
end

module Ping

  Bot.register_application_command(:valorant_stats, 'Check your Valorant stats', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil))
  Bot.register_application_command(:link_valorant_account, 'Link your Valorant account by changing your ingame title', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)) do |cmd|
    cmd.string('name', 'Username', required: true)
    cmd.string('tag', 'Tagline', required: true)
    cmd.string('title', 'Title', required: true)
  end

  Bot.register_application_command(:link_terraria_account, 'Link your Terraria account to your Discord account', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil))


  Bot.application_command(:spongecase) do |event|
    ops = %i[upcase downcase]
    text = event.options['message'].chars.map { |x| x.__send__(ops.sample) }.join
    event.respond(content: text)

    event.send_message(content: 'https://pyxis.nymag.com/v1/imgs/09c/923/65324bb3906b6865f904a72f8f8a908541-16-spongebob-explainer.rsquare.w700.jpg') if event.options['with_picture']
  end

  Bot.button(custom_id: /^test_button:/) do |event|
    num = event.interaction.button.custom_id.split(':')[1].to_i

    event.update_message(content: num.to_s, ephemeral: true) do |_, view|
      view.row do |row|
        row.button(label: '', style: :danger, custom_id: "test_button:#{num - 1}", emoji: { name: "❌" })
        row.button(label: '', style: :success, custom_id: "test_button:#{num + 1}", emoji: { name: "✅" })
      end
    end
  end

  Bot.select_menu(custom_id: 'test_select') do |event|
    event.respond(content: "You selected: #{event.values.join(', ')}")
  end

  Bot.application_command(:valorant_stats) do |event|
    puts event.user.inspect
    StatsService.new(event.user).call
  end

  Bot.application_command(:link_valorant_account) do |event|
    account = get_account(event.options["name"], event.options["tag"])
    puts account
    if account[:success]
      title = get_title(account[:title])
      puts title
      if title != event.options["title"]
        puts "i shouldn't be here"
        event.respond(content: "To verify this is your account please change your account title to #{event.options["title"]} and click the confirm button\n
                                You can revert the change after account verification", ephemeral: true) do |_, view|
          view.row do |r|
            r.button(label: 'Confirm account linkage', style: :primary, emoji: { name: "✅" }, custom_id: "account_link_button:#{event.options["name"]},#{event.options["tag"]},#{event.options["title"]}")
          end
        end
      else
        event.respond(content: "Change your title to one that is not currently set on your profile")
      end
    else
      event.respond(content: 'No such account exists on EU servers')
    end
  end

  Bot.application_command(:link_terraria_account) do |event|
    if User.find(event.user.id).steam_id.present?
      event.respond(content: "You have already linked your account", ephemeral: true)
    else
      verification_value = SecureRandom.hex(16)
      $redis.set(verification_value.to_s, event.user.id)
      $redis.expire(verification_value.to_s, 60 * 5)
      event.respond(content: "To link your Terraria account please connect to the server\n
                            IP: nashar101.ddns.net\n
                            Password: V@lor4ntSvCks101\n
                            And type /link #{verification_value.to_s}.\n
                            After you have done the aforementioned actions you will be notified about the account linkage.\n
                            You have 5 minutes.
                            and click the confirm button\n", ephemeral: true)
    end
  end



  Bot.button(custom_id: /^account_link_button:/) do |event|
    full_name = event.interaction.button.custom_id.split(':')[1].split(",")

    account = get_account(full_name[0], full_name[1])
    if get_title(account[:title]) == full_name[2]
      discord_user = User.find(event.user.id)
      discord_user.valorant_id = account[:id]
      discord_user.save!
      event.update_message(content: "Your account has being successfully linked!", ephemeral: true)
    else
      event.update_message(content: "You did not change your title correctly", ephemeral: true)
    end

    # if check_account_exists(name_and_tag[0], name_and_tag[1])[:success]
    #   discord_user = User.find(event.user.id)
    #   discord_user.valorant_id
    # end
  end

  Bot.member_join do |event|
    User.create(user_id: event.user.id, valorant_id: nil, steam_id: nil)
  end

end