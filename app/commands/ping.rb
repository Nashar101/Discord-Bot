module Ping
    Bot.register_application_command(:example, 'Example commands', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)) do |cmd|
  cmd.subcommand_group(:fun, 'Fun things!') do |group|
    group.subcommand('8ball', 'Shake the magic 8 ball') do |sub|
      sub.string('question', 'Ask a question to receive wisdom', required: true)
    end

    group.subcommand('java', 'What if it was java?')

    group.subcommand('calculator', 'do math!') do |sub|
      sub.integer('first', 'First number')
      sub.string('operation', 'What to do', choices: { times: '*', divided_by: '/', plus: '+', minus: '-' })
      sub.integer('second', 'Second number')
    end

    group.subcommand('button-test', 'Test a button!')
  end
end


Bot.register_application_command(:spongecase, 'Are you mocking me?', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)) do |cmd|
  cmd.string('message', 'Message to spongecase')
  cmd.boolean('with_picture', 'Show the mocking sponge?')
end

Bot.register_application_command(:valorant_stats, 'Check your Valorant Stats', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil))
# This is a really large and fairly pointless example of a subcommand.
# You can also create subcommand handlers directly on the command like so
#    Bot.application_command(:other_example).subcommand(:test) do |event|
#      # ...
#    end
#    Bot.application_command(:other_example).subcommand(:test2) do |event|
#      # ...
#    end
Bot.application_command(:example).group(:fun) do |group|
  group.subcommand('8ball') do |event|
    wisdom = ['Yes', 'No', 'Try Again Later'].sample
    event.respond(content: <<~STR, ephemeral: true)
      ```
      #{event.options['question']}
      ```
      _#{wisdom}_
    STR
  end

  group.subcommand(:java) do |event|
    javaisms = %w[Factory Builder Service Provider Instance Class Reducer Map]
    jumble = []
    [*5..10].sample.times do
      jumble << javaisms.sample
    end

    event.respond(content: jumble.join)
  end

  group.subcommand(:calculator) do |event|
    result = event.options['first'].send(event.options['operation'], event.options['second'])
    event.respond(content: result)
  end

  group.subcommand(:'button-test') do |event|
    event.respond(content: 'Button test', ephemeral: true) do |_, view|
      view.row do |r|
                r.button(label: 'Test!', style: :primary, emoji: { id: 1382459989469433920, name: "Hyetta" }, custom_id: 'test_button:1')
        end
    end
  end
end

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
    puts event.user.avatar_url
    puts ENV.fetch("SLASH_COMMAND_BOT_SERVER_ID", nil)
    StatsService.new(event.user.username).call
end

end