require 'telegram/bot'
require_relative 'cart'
require 'dotenv'
Dotenv.load('./lib/token.env')

# rubocop: disable Metrics/CyclomaticComplexity, Metrics/LineLength, Metrics/MethodLength, Metrics/AbcSize

class Bot
  def initialize
    @state = 0
    @states = {}
    @orders = {}
    @adress = {}
    @carts = {}
    @pizzas = { 1 => { 'name' => 'Cheese Pizza', 'price' => 8 },
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

  def store_order(_bot, client, order, id)
    @carts[id] = Cart.new(id) if @carts[id].nil?
    order = order.to_i
    @orders[id] = order
    @states[client.chat.id] = 3
  end

  def finish_order(bot, client, id)
    names = @carts[id].name_to_string(id)
    total = @carts[id].cart_total(id)
    bot.api.send_message(chat_id: client.chat.id,
                         text: "You bought #{names}\r\nFor the total of R$#{total}\r\nTo the adress: #{@adress[id]}\r\nThanks for shopping with PizzaBot")
    pizza_stop(bot, client, id)
  end

  def bot_logic
    @token = ENV['MY_TOKEN']
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |client|
        @states[client.chat.id] = 0 unless @states[client.chat.id]
        @first = client.from.first_name
        @last = client.from.last_name
        case client.text
        when '/start'
          @states[client.chat.id] = 0
          send_start(bot, client)
        when '/pizza'
          pizza_listen(bot, client, client.chat.id)
        when '/stop'
          stop_listen(bot, client, client.chat.id)
        when '/confirm'
          confirm_listen(bot, client, client.chat.id)
        when '/back'
          if @states[client.chat.id] == 2 or @states[client.chat.id] == 3
            @states[client.chat.id] = 2
            check_state(bot, client, client.chat.id, client.text)
          end
        when '/finish'
          finish_order(bot, client, client.chat.id) if @states[client.chat.id] == 4
        when '/again'
          if @states[client.chat.id] == 4
            @states[client.chat.id] = 2
            check_state(bot, client, client.chat.id, client.text)
          end
        else
          check_state(bot, client, client.chat.id, client.text)
        end
      end
    end
  end

  def pizza_listen(bot, client, id)
    @states[id] = 1
    ask_adress(bot, client, id)
  end

  def stop_listen(bot, client, id)
    @states[id] = 0
    pizza_stop(bot, client, id)
  end

  def confirm_listen(bot, client, id)
    add_to_cart(bot, client, client.chat.id)
    finish(bot, client, id)
  end

  def finish(bot, client, id)
    @states[id] = 4
    bot.api.send_message(chat_id: client.chat.id,
                         text: 'Type /finish to finish your order, or /again to order another pizza')
  end

  def pizza_stop(bot, client, id)
    @adress[id] = nil
    @orders[id] = nil
    @carts[id] = nil
    bot.api.send_message(chat_id: client.chat.id,
                         text: "Thanks for talking with pizzabot, if you'd like to start again, press /start")
  end

  def check_state(bot, client, id, text)
    if @states[id] == 1
      @states[id] = 2
      get_adress(text, id)
      pizza_option(bot, client)
    elsif (@states[id] == 2) && (check_pizza(text) == false)
      pizza_option(bot, client)
    elsif @states[id] == 2
      @states[id] = 3
      store_order(bot, client, text, id)
      confirm_order(bot, client, id)
    end
  end

  def add_to_cart(_bot, _client, id)
    @carts[id].push_to_cart(id, @pizzas[@orders[id]]['name'], @pizzas[@orders[id]]['price'])
  end

  def check_pizza(pizza)
    pizza = pizza.to_i
    @pizzas.key?(pizza) || false
  end

  def confirm_order(bot, client, id)
    bot.api.send_message(chat_id: client.chat.id,
                         text: "Please type /confirm to confirm your order of a #{@pizzas[@orders[id]]['name']} for R$#{@pizzas[@orders[id]]['price']} or /back to go back")
  end

  def pizza_text(input)
    "#{@pizzas[input]['name']} for R$#{@pizzas[input]['price']}"
  end

  def ask_adress(bot, client, _id)
    bot.api.send_message(chat_id: client.chat.id, text: 'Please type in your adress')
  end

  def get_adress(adress, id)
    @adress[id] = adress
  end
end

# rubocop: enable Metrics/CyclomaticComplexity, Metrics/LineLength, Metrics/MethodLength, Metrics/AbcSize

