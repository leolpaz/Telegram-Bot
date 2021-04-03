require_relative '../lib/cart'

test1 = Cart.new(123)
test2 = Cart.new(245)

describe Cart do
  let(:client_id1) { 123 }
  let(:client_id2) { 245 }
  let(:carts) { {} }
  test1.push_to_cart(123, 'apple', 2)
  test1.push_to_cart(123, 'banana', 3)
  test1.push_to_cart(123, 'strawberry', 4)
  test1.push_to_cart(123, 'orange', 5)
  test2.push_to_cart(245, 'coke', '2')
  test2.push_to_cart(245, 'pepsi', '3')
  test2.push_to_cart(245, 'orange soda', '4')
  test2.push_to_cart(245, 'grape soda', '5')
  describe '#push_to_cart' do
    it 'returns the price of all elements' do
      test1.push_to_cart(123, 'watermelon', 6)
      expect(test1.carts[client_id1]['price']).to eql([2, 3, 4, 5, 6])
    end
    it 'cannot push to two different carts at once' do
      expect { test1.push_to_cart(client_id1, client_id2, 'test', 'fail') }.to raise_error(ArgumentError)
    end
  end
  describe '#name_to_string' do
    it 'return the names as string without []' do
      expect(test1.name_to_string(client_id1)).to eql('apple, banana, strawberry, orange, watermelon')
    end
    it 'cannot transform two different carts into a single string' do
      expect { test1.name_to_string(client_id1, client_id2) }.to raise_error(ArgumentError)
    end
  end
  describe '#cart_total' do
    it 'sums the values on the cart' do
      expect(test1.cart_total(client_id1)).to eql(20)
    end
    it 'only handles integers correctly' do
      expect(test2.cart_total(client_id2)).not_to eql(14)
    end
    it 'does not sum two different carts' do
      expect { test1.cart_total(client_id1, client_id2) }.to raise_error(ArgumentError)
    end
  end
end
