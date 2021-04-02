require_relative '../lib/cart'

describe Cart do
  let(:client_id) { 123 }
  let(:test) { Cart.new(client_id) }
  let(:carts) { {} }
  describe '#push_to_cart' do
    it 'returns the price of the element in the cart' do
      test.push_to_cart(client_id, 'orange', 2)
      expect(test.carts[client_id]['price']).to eql([2])
    end
    it 'returns multiple elements' do
      test.push_to_cart(client_id, 'orange', 2)
      test.push_to_cart(client_id, 'orange', 3)
      test.push_to_cart(client_id, 'orange', 4)
      test.push_to_cart(client_id, 'orange', 5)
      expect(test.carts[client_id]['price']).to eql([2, 3, 4, 5])
    end
  end
  describe '#name_to_string' do
    it 'return the names as string without []' do
      test.push_to_cart(client_id, 'apple', 2)
      test.push_to_cart(client_id, 'banana', 3)
      test.push_to_cart(client_id, 'strawberry', 4)
      test.push_to_cart(client_id, 'orange', 5)
      expect(test.name_to_string(client_id)).to eql('apple, banana, strawberry, orange')
    end
  end
  describe '#cart_total' do
    it 'sums the values on the cart' do
      test.push_to_cart(client_id, 'apple', 2)
      test.push_to_cart(client_id, 'banana', 3)
      test.push_to_cart(client_id, 'strawberry', 4)
      test.push_to_cart(client_id, 'orange', 5)
      expect(test.cart_total(client_id)).to eql(14)
    end
  end
end
