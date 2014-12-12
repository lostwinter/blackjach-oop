# [Tealeaf - Week 2] OOP Blackjack Game

class Card
  attr_accessor :value, :suit
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "The #{value} of #{suit}."
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
      ['Hearts', 'Diamonds', 'Spades', 'Clubs'].each do |suit|
        ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |value|
            @cards << Card.new(suit, value)
        end
      end
      shuffle!
  end

  def shuffle!
    cards.shuffle!
  end

  def deal
    cards.pop
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts "#{name}'s Hand"
    cards.each do |card|
      puts "#{card}"
    end
    puts "Total = #{total}"
  end

  def add_card(new_card)
    cards << new_card
  end
   
  def bust?
    if total > 21
      puts "#{name} busts"
    end
  end

  def total 
    values = cards.map{ |card| card.value }
    total = 0
    values.each do |value|
      if value == "Ace"
        total += 11
      else
        total += (value.to_i == 0 ? 10 : value.to_i)
      end

      values.select{|v| v == "Ace"}.count.times do 
        break if total <= 21
        total -= 10
      end
    end
    total
  end
end

class Player
  include Hand
  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def get_name
    @name = gets.chomp
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end
end

deck = Deck.new
player = Player.new("Bobby")
player.add_card(deck.deal)
player.add_card(deck.deal)
player.add_card(deck.deal)
player.show_hand
player.total
player.bust?

dealer = Dealer.new
dealer.add_card(deck.deal)
dealer.add_card(deck.deal)
dealer.add_card(deck.deal)
dealer.show_hand
dealer.total
dealer.bust?