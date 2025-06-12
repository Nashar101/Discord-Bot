require "discordrb"
# rubocop:disable Style/NumericLiterals
ChannelID = 1378218382025031780
Bot = Discordrb::Bot.new(
    token: Rails.application.credentials.dig(:discord, :token),
    client_id: Rails.application.credentials.dig(:discord, :client_id),
)

Dir["#{Rails.root}/app/commands/*.rb"].each{
 |file| require file
}
Bot.run(true)

puts "Invite URL: #{Bot.invite_url}"