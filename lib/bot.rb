require 'telegram/bot'

class Bot
  def initialize
    @state = 0
    @states = {}
    @orders = {}
    @adress = {}
    @pizzas = { 1 => { 'name' => 'Cheese Pizza', 'price' => '8' },
                2 => { 'name' => 'Cheese and Ham Pizza', 'price' => 10 }, 3 => { 'name' => 'Meat Pizza', 'price' => 15 }, 4 => { 'name' => 'Cream Cheese and Chicken Pizza', 'price' => 20 } }
    bot_logic
  end

  private

  def send_start(bot, client)
    bot.api.send_message(chat_id: client.chat.id,
                         text: "Hello #{@first} #{@last}, welcome to my pizza bot, can I take your order? type /pizza to start or /stop to stop")
  end

  def pizza_option(bot, client)
    pizza_text = "Hi, your options are: \r\n 1 - #{pizza_text(1)} \r\n 2 - #{pizza_text(2)} \r\n 3 - #{pizza_text(3)} \r\n 4 - #{pizza_text(4)}, \r\n type the number of the pizza that you want to proceed."
    bot.api.send_message(chat_id: client.chat.id, text: pizza_text)
  end

  def store_order(bot, client, order, id)
    order = order.to_i
    @orders[id] = order
    bot.api.send_message(chat_id: client.chat.id,
                         text: "You just choose a delicious #{pizza_text(@orders[id])} please give us your adress")
    @states[client.chat.id] = 3
  end

  def finish_order(bot, client, id)
    bot.api.send_message(chat_id: client.chat.id,
                         text: " You bought a #{@pizzas[@orders[id]]['name']}\r\n The price is R$#{@pizzas[@orders[id]]['price']} to be delivered at #{@adress[id]}\r\n Thanks for buying with pizzabot")
  end

  def bot_logic
    token = '1738560528:AAGEZPyiMmEb9ov6yiumgqLdXXQKoWUjCBQ'
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |client|
        @states[client.chat.id] = 0 unless @states[client.chat.id]
        @first = client.from.first_name
        @last = client.from.last_name
        @new_cart = Cart.new(client.chat.id)
        case client.text
        when '/start'
          @states[client.chat.id] = 0
          send_start(bot, client)
        when '/pizza'
          @states[client.chat.id] = 1
          pizza_option(bot, client)
        else
          check_state(bot, client, client.chat.id, client.text)
        end
      end
    end
  end

  def check_state(bot, client, id, text)
    if (@states[id] == 1) && (check_pizza(text) == false)
      pizza_option(bot, client)
    elsif @states[id] == 1
      @states[id] = 2
      store_order(bot, client, text, id)
    elsif @states[id] == 3
      get_adress(text, id)
      finish_order(bot, client, id)
    end
  end

  def check_pizza(pizza)
    pizza = pizza.to_i
    @pizzas.key?(pizza) || false
  end

  def pizza_text(input)
    "#{@pizzas[input]['name']} for R$#{@pizzas[input]['price']}"
  end

  def get_adress(adress, id)
    @adress[id] = adress
  end
end
