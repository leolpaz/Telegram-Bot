class Cart
   attr_reader :client_id, :carts

  def initialize(client_id)
    @client_id = client_id.to_i
    @carts = {}
    @carts[client_id] = {}
    @carts[client_id].store('name', [])
    @carts[client_id].store('price', [])
  end

  def push_to_cart(_client_id, name, price)
    @carts[@client_id]['name'].push(name)
    @carts[@client_id]['price'].push(price)
  end

  def name_to_string(_client_id)
    @carts[@client_id]['name'] * ', '
  end

  def cart_total(_client_id)
    @carts[@client_id]['price'].reduce { |sum, n| sum + n }
  end
end
