require 'telegram/bot'


class Bot

    def initialize
      @state = 0
      @states = {}
      @orders = {}
      @adress = {}
      @pizzas = {1 => {'name' => 'Cheese Pizza', 'price' => '8'}, 2 => {'name' => 'Cheese and Ham Pizza', 'price' => 10}, 3 => {'name' => 'Meat Pizza', 'price' => 15}, 4 => {'name' => 'Cream Cheese and Chicker Pizza', 'price' => 20}}

    Telegram::Bot::Client.run(@@token) do |bot|
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
          elsif @states[client.chat.id] == 1
            @states[client.chat.id] = 2
            store_order(bot, client, client.text, client.chat.id)
          elsif @states[client.chat.id] == 3
            get_adress(client.text, client.chat.id)
            finish_order(bot, client, client.chat.id)
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
    pizza_text = "Hi, your options are: \r\n 1 - #{@pizzas[1]['name']} for R$#{@pizzas[1]['price']} \r\n 2 - #{@pizzas[2]['name']} for R$#{@pizzas[2]['price']} \r\n 3 - #{@pizzas[3]['name']} for R$#{@pizzas[3]['price']} \r\n 4 - #{@pizzas[4]['name']} for R$#{@pizzas[4]['price']}, \r\n type the number of the pizza that you want to proceed."
    bot.api.send_message(chat_id: client.chat.id, text: pizza_text)
  end

  def store_order(bot, client, order, id)
    order = order.to_i
    @orders[id] = order
    p order 
    case order
    when 1
      bot.api.send_message(chat_id: client.chat.id, text: "You just choose a delicious #{@pizzas[order]['name']} for R$#{@pizzas[order]['price']} please give us your adress")
      @states[client.chat.id] = 3
    when 2
      bot.api.send_message(chat_id: client.chat.id, text: "You just choose a delicious #{@pizzas[order]['name']} for R$#{@pizzas[order]['price']} please give us your adress")
      @states[client.chat.id] = 3
    when 3
      bot.api.send_message(chat_id: client.chat.id, text: "You just choose a delicious #{@pizzas[order]['name']} for R$#{@pizzas[order]['price']} please give us your adress")
      @states[client.chat.id] = 3
    when 4
      bot.api.send_message(chat_id: client.chat.id, text: "You just choose a delicious #{@pizzas[order]['name']} for R$#{@pizzas[order]['price']} please give us your adress")
      @states[client.chat.id] = 3
    end
  end


  private
  @@token = '1738560528:AAGEZPyiMmEb9ov6yiumgqLdXXQKoWUjCBQ'

  def check_pizza(pizza)
    pizza = pizza.to_i
    if @pizzas.key?(pizza)
      @pizzas.key?(pizza)
    else
      false
    end
  end

  def get_adress(adress, id)
    @adress[id] = adress
    p @adress[id]
  end

end