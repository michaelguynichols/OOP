require 'pry'

class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def sort_cards
    cards_values_copy = []
    sorted_copy = []
    cards.each do |card|
      cards_values_copy << card.worth
    end
    while sorted_copy.count < cards.count
      maximum = cards_values_copy.max
      cards.each do |card|
        if maximum == card.worth
          sorted_copy << card
          cards_values_copy.delete(card.worth)
        end
      end
    end
    sorted_copy
  end

  def value
    copy_of_sorted_cards = sort_cards
    total = 0
    copy_of_sorted_cards.each do |card|
      if card.card_representation == 'A' && card.worth + total > 21
        total += 1
      else
        total += card.worth
      end
    end
    total
  end

  def [](from, to)
    i = from
    formatted_cards = []
    while i < to
      formatted_cards << @cards[i].card_representation
      i += 1
    end
    formatted_cards
  end

  def size
    cards.count
  end

  def to_s
    "#{cards}"
  end
end

class Card
  VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7,
             8 => 8, 9 => 9, 10 => 10, 11 => 10, 12 => 10,
             13 => 10, 14 => 11 }
  ROYALS = { 11 => "J", 12 => "Q", 13 => "K", 14 => "A" }

  attr_accessor :suit, :value

  def initialize(s, v)
    @suit = s
    @value = v
  end

  def card_representation
    if value < 11
      VALUES[value]
    else
      ROYALS[value]
    end
  end

  def worth
    VALUES[@value]
  end
end

class Deck
  SUITS = %w(Hearts Diamonds Clubs Spades)

  attr_accessor :deck

  def initialize
    @deck = build_deck
  end

  def build_deck
    initial_deck = []
    SUITS.each do |suit|
      Card::VALUES.keys.each do |card_value|
        initial_deck << Card.new(suit, card_value)
      end
    end
    initial_deck
  end

  def deal_card
    dealt_card = nil
    while !dealt_card
      dealt_card = deck.sample
    end
    @deck.delete(dealt_card)
    dealt_card
  end
end

class Player
  attr_accessor :hand
  attr_reader :name

  def initialize
    @hand = Hand.new
    @name = "You"
  end

  def show_cards
    cards = hand[0, hand.size - 1].join(', ')
    last_card = hand[hand.size - 1, hand.size].join
    if hand.size > 2
      puts "#{name} have: #{cards}, and #{last_card} worth #{hand.value}"
    else
      puts "#{name} have: #{cards} and #{last_card} worth #{hand.value}"
    end
  end
end

class Dealer
  attr_accessor :hand
  attr_reader :name

  def initialize
    @hand = Hand.new
    @name = "Dealer"
  end

  def show_cards
    cards = hand[0, hand.size - 1].join(', ')
    if hand.size > 2
      puts "#{name} have: #{cards}, and unknown card"
    else
      puts "#{name} has: #{cards} and unknown card"
    end
  end

  def show_final_result
    cards = hand[0, hand.size - 1].join(', ')
    last_card = hand[hand.size - 1, hand.size].join
    if hand.size > 2
      puts "#{name} have: #{cards}, and #{last_card} worth #{hand.value}"
    else
      puts "#{name} have: #{cards} and #{last_card} worth #{hand.value}"
    end
  end
end

class Game
  WIN_SCORE = 21
  DEALER_STOP_SCORE = 17
  ROUNDS = 5

  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    deal_cards
    show_initial_cards
    player_turn
    show_cards
    dealer_turn
    show_result
  end

  private

  def deal_cards
    2.times { player.hand.add_card(deck.deal_card) }
    2.times { dealer.hand.add_card(deck.deal_card) }
  end

  def show_initial_cards
    show_cards
  end

  def show_cards
    system 'clear'
    puts "-----"
    puts "Your hand: "
    player.show_cards
    puts "-----"
    puts "Dealer's hand: "
    dealer.show_cards
    puts "-----"
  end

  def player_hit
    player.hand.add_card(deck.deal_card)
  end

  def dealer_hit
    dealer.hand.add_card(deck.deal_card)
  end

  def player_bust?
    player.hand.value > WIN_SCORE
  end

  def dealer_bust?
    dealer.hand.value > WIN_SCORE
  end

  def show_winner
    if player_bust?
      dealer.name
    elsif dealer_bust?
      player.name
    elsif player.hand.value > dealer.hand.value
      player.name
    elsif dealer.hand.value >= player.hand.value
      dealer.name
    end
  end

  def player_turn
    loop do
      puts "Would you like to hit or stay? (h or s)"
      choice = nil
      loop do
        choice = gets.chomp
        break if choice.downcase == 'h' || choice.downcase == 's'
        puts "Please enter a valid choice: h or s"
      end
      break if choice.downcase == 's'
      player_hit
      break if player_bust?
      show_cards
    end
  end

  def dealer_turn
    if !player_bust?
      while dealer.hand.value < DEALER_STOP_SCORE
        dealer_hit
        break if dealer_bust?
        show_cards
      end
    end
  end

  def show_result
    system 'clear'
    puts "Your hand: "
    player.show_cards
    puts "-----"
    puts "Dealer's hand: "
    dealer.show_final_result
    puts "-----"
    if player_bust?
      puts "#{player.name} busted!"
    elsif dealer_bust?
      puts "#{dealer.name} busted!"
    end
    puts "#{show_winner} won!"
  end
end

game = Game.new
game.start
