require 'telegram/bot'
require_relative 'pizza.rb'

class Bot
  def initialize
    token = '1738560528:AAGEZPyiMmEb9ov6yiumgqLdXXQKoWUjCBQ'

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |client|
        @@first = client.from.first_name
        @@last = client.from.last_name
        case client.text
        when '/start'
          initial_text = 'Hello'
          bot.api.send_message(chat_id: client.chat.id, text: "#{initial_text} #{@@first} #{@@last}")
        else
          bot.api.send_message(chat_id: client.chat.id, text: "oops")
        end
      end
    end
  end
end