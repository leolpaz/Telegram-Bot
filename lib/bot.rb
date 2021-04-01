require 'telegram/bot'


class Bot

    def initialize
      token = '1738560528:AAGEZPyiMmEb9ov6yiumgqLdXXQKoWUjCBQ'
      @state = 0
      @states = {}
      @pizzas = {1 => 8, 2 => 10, 3 => 15, 4 => 18}
      @valid_pizza = false

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |client|
        @states[client.chat.id] = 0 unless @states[client.chat.id]
        @@first = client.from.first_name
        @@last = client.from.last_name
        case client.text
        when '/start'
          @state = 0
          send_start(bot, client)
        when '/pizza'
          @states[client.chat.id] = 1
          pizza_option(bot, client)
        else
          if @states[client.chat.id] == 1 and check_pizza(client.text) == false
            pizza_option(bot, client)
          else
            @states[client.chat.id] = 2
            store_order(client.text)
          end
        end
      end
    end
  end

  def send_start(bot, client)
    initial_text = 'Hello'
    bot.api.send_message(chat_id: client.chat.id, text: "Hello #{@@first} #{@@last}, welcome to my pizza bot, can I take your order? type /pizza to start or /stop to stop")
  end

  def pizza_option(bot, client)
    pizza_text = "Hi, your options are: \r\n 1 - Cheese for R$#{@pizzas[1]} \r\n 2 - Cheese and Ham for R$#{@pizzas[2]} \r\n 3 - Meat for R$#{@pizzas[3]} \r\n 4 - Cream Cheese and Chicken for R$#{@pizzas[4]}, \r\n type the number of the pizza that you want to proceed."
    bot.api.send_message(chat_id: client.chat.id, text: pizza_text)
  end

  def check_pizza(pizza)
    pizza = pizza.to_i
    if @pizzas.key?(pizza)
      @pizzas.key?(pizza)
      @valid_pizza
    else
      false
    end
  end

  def store_order(order)
    @order = order.to_i
  case @order
  when @order == 1
    bot.api.send_message(chat_id: client.chat.id, text: pizza_text)
  end
  
end