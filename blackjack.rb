# [Tealeaf - Week 2] OOP Blackjack Game

module Hand
  def show_hand
    puts "#{name}'s Hand"
    cards.each do |card|
      puts "#{card}"
    end
    puts "Total = #{total}"
  end

  def show_flop
    show_hand
  end

  def add_card(new_card)
    cards << new_card
  end
   
  def bust?
    if total > 21
      puts "#{name} busts"
      exit
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

  def show_flop
    puts "Dealer's hand:"
    puts "Card 1: #####"
    puts "Card 2: #{cards[1]}"
  end
end

class Game
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new("Player 1")
    @dealer = Dealer.new
  end

  def say(msg)
    puts ">> #{msg}"
  end

  def get_name
    say "Welcome to blackjack!"
    say ""
    say "What's your name?"
    name = gets.chomp
    say "Okay #{name}, let's play."
    name
  end

  # def replay?
  #   loop do
  #     puts "Do you want to play again? (Y/N)"
  #     reply = gets.chomp.upcase
  #     Game.new.play if reply == 'Y'
  #   end until reply.eql?('Y' || 'N')
  # end

  def deal_cards
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == 21
      if player_or_dealer.is_a?(Dealer)
        puts "Dealer hits Blackjack. #{player.name} lose."
        exit
      else 
        puts "You hit Blackjack. #{player.name} win!"
        exit
      end
    elsif player_or_dealer.bust?
        if player_or_dealer.is_a?(Dealer)
          puts "Dealer busts. You win!"
          exit
        else
          puts "Sorry brah, you busted."
          exit
        end
    end
  end

  def player_turn
    puts "#{player.name}'s turn."

    blackjack_or_bust?(player)

    while !player.bust?
      puts "Do you want to hit or stay?"
      hit_or_stay = gets.chomp.downcase
  
      if !['hit', 'stay'].include?(hit_or_stay)
        puts "Error. Enter 'hit' or 'stay.'"
        next
      end
      if hit_or_stay == 'stay'
        puts "#{player.name} stays."
        break
      end

      if hit_or_stay == 'stay'
        puts "#{player.name} chooses to stay."
        break
      end

      new_card = deck.deal
      puts "Dealing a card... You get #{new_card}"
      puts "Your new total is #{player.total}."
      player.add_card(new_card)
      puts "#{player.name}'s new total is #{player.total}."

      blackjack_or_bust?(player)
    end
    puts "You stay."
  end
 
  def dealer_turn
    puts "Dealer's turn...."
    blackjack_or_bust?(dealer)

    while dealer.total < 16
      puts "Dealer's total is #{dealer.total}. Dealer hits...."
      new_card = deck.deal
      dealer.add_card(new_card)
      puts "Dealer's new total is #{dealer.total}."
      blackjack_or_bust?(dealer)
    end
  end

  def who_won?
    if player.total == dealer.total
      puts "It's a tie. Push!"
    elsif player.total > dealer.total
      puts "#{player.name} has #{player.total} and dealer has #{dealer.total}. You win!!!"
    else
      puts "#{player.name} has #{player.total} and dealer has #{dealer.total}. You lose. Bummer."  
    end    
  end

  def play
    get_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
    replay?
  end
end

game = Game.new
game.play 