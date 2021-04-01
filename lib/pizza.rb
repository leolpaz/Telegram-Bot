class Pizza
  attr_reader :pizzas
  @@prices = [8, 10, 15, 18]
  def initialize
    @@pizzas ||= {Cheese: @@prices[0], Cheese_and_Ham: @@prices[1], Meat: @@prices[3], Cream_Cheese_and_Chicken: @@prices[4]}
  end
end