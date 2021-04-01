require 'telegram/bot'
require_relative 'pizza'

class Bot

    def initialize
      token = '1738560528:AAGEZPyiMmEb9ov6yiumgqLdXXQKoWUjCBQ'
      @@response = Pizza.new

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |client|
        @@first = client.from.first_name
        @@last = client.from.last_name
        case client.text
        when '/start'
          initial_text = 'Hello'
          bot.api.send_message(chat_id: client.chat.id, text: "Hello #{@@first} #{@@last}, welcome to my pizza bot, can I take your order? type /pizza to start or /stop to stop")
        when '/pizza'
          pizza_option()
        else
          @@response.api.send_message(chat_id: client.chat.id, text: "oops")
        end
      end
    end
  end

  def pizza_option
    pizza_text = "Hi, your options are #{@@pizzas[0]} for R$#{@@pizzas['Cheese']} or #{@@pizzas[1]} for R$#{@@pizzas[:Cheese_and_Ham]} or #{@@pizzas[2]} for R$#{@@pizzas[:Meat]} or #{@@pizzas[3]} for R$#{@@pizzas[:Cream_Cheese_and_Chicken]} "
    bot.api.send_message(chat_id: type.chat.id, text: pizza_text)
  end

  
end