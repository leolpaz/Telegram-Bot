class Cart
  attr_reader :client_id
  attr_accessor :carts
  def initialize(client_id)
    @client_id = client_id.to_i
    @carts = {}
    @carts[client_id] = {}
    @carts[client_id].store('name', [])
    @carts[client_id].store('price', [])
  end


  def push_to_cart(client_id, name, price)
    @carts[@client_id]['name'].push(name)
    @carts[@client_id]['price'].push(price)
  end
end