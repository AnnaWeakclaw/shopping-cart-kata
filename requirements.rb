=begin
Write the code for a supermarket checkout that can calculate the price of any number of items taken from a predetermined list.
Each item should be priced individually, and the checkout should be able to scan them in any order.

The requirements for the system are as follows:

As a shopper DONE
So I know how much an item costs
I would like to be able to see its price

As a shopper DONE
So that I can buy an item
I would like to be able to scan items at the checkout

As a shopper PARTIALLY DONE
So that I know if I have made a mistake
I should be informed if I attempt to buy an item which is not available

As a shopper DONE
So that I know how much to pay
I would like to be able to see a total for all scanned items

As a shopper DONE
So that I know how much to pay
I would like to see all prices correctly formatted (£xx.xx)

As a shopper DONE
So that I am not left out of pocket
I would like to receive the correct change once I have completed my transaction
=end
require 'bigdecimal'

class Checkout

  def initialize
    @item_list = []
  end

  def add(item)
    if item.nil?
      puts "Out of stock"
    else
    @item_list.push(item)
    end
  end

  def total_cost
    total = 0
    @item_list.each do |item|
      item.each do |key, value|
        total += value
      end
    end
    total
  end

  def print_total_cost
    total = total_cost
    string = (total.truncate(2).to_s('F') + '00')[ /.*\..{2}/ ]
    puts "You will pay £#{string}"
  end

  def show_cart
    @item_list.each { |item|
      item.each { |k, v|
        string = (v.truncate(2).to_s('F') + '00')[ /.*\..{2}/ ]
        puts "#{k} for £#{string}"
      }
    }
  end

  def print
    @item_list.each do |item|
      item.each do |key, value|
        string = (value.truncate(2).to_s('F') + '00')[ /.*\..{2}/ ]
        puts "The exact price for #{key} is £#{string}"
      end
    end
  end
end

class Item

  def initialize(kind, price, amount)
    @kind = kind
    @price = BigDecimal("#{price}")
    @amount = amount
    if @amount > 0
      @available = true
    else
      @available = false
    end
  end

  def print
    string = (@price.truncate(2).to_s('F') + '00')[ /.*\..{2}/ ]
    puts "Price of a #{@kind} is #{string}"
  end

  def buy
    if @available
    @amount -= 1
    item_hash = { @kind => @price }
    else
      item_hash = nil
    end
  end

  def one_less
    @amount
  end

end

class Stock
  def initialize(amount)
    @amount = amount
  end

  def count
    @amount
  end
end

class Transaction
  def initialize(total, money)
    @total = total
    @money = money
  end

  def payment
    string = ((@money - @total).truncate(2).to_s('F') + '00')[ /.*\..{2}/ ]
    puts "Here's your change: £#{string}"
  end
end

class Shopper

tshirt = Item.new("tshirt", 12.99, Stock.new(2).count)
leggins = Item.new("leggins", 9.55, Stock.new(6).count)
shoes = Item.new("shoes", 30.20, Stock.new(0).count)
#I want to see the prices
tshirt.print
leggins.print
shoes.print

#I want to add my items to a shopping basket
shopping_bag = Checkout.new
shopping_bag.add(tshirt.buy)
shopping_bag.add(leggins.buy)
shopping_bag.add(shoes.buy)

#I want to see what is in my basket
shopping_bag.show_cart

#I want to know how much I will have to pay
shopping_bag.print_total_cost

#I want to se the exact prices
shopping_bag.print

#I want to receive change after completing Transaction
payment = Transaction.new(shopping_bag.total_cost, 100)
payment.payment

#I want to know the affect my shopping has on stock

end
