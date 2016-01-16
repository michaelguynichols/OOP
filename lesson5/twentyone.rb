SUITS = %w(Hearts Diamonds Clubs Spades)
CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7,
           8 => 8, 9 => 9, 10 => 10, 11 => 10, 12 => 10,
           13 => 10, 14 => 11 }
ROYALS = { 11 => "J", 12 => "Q", 13 => "K", 14 => "A" }
PLAYER = "You"
COMPUTER = "Dealer"
WIN_SCORE = 21
DEALER_STOP_SCORE = 17
ROUNDS = 5

def prompt(message)
  puts "=> #{message}"
end

def build_deck
  deck = {}
  SUITS.each do |suit|
    CARDS.each do |card|
      if deck.key?(suit)
        deck[suit] << card
      else
        deck[suit] = [card]
      end
    end
  end
  deck
end

def build_card_representations(cards)
  reps = []
  cards.each do |card|
    if card.to_i > 10
      reps << ROYALS[card]
    else
      reps << card
    end
  end
  reps
end

def deal_card(deck_of_cards)
  dealt_card = nil
  while dealt_card == nil
    random_suit = SUITS.sample
    dealt_card = deck_of_cards[random_suit].sample
    deck_of_cards[random_suit].delete(dealt_card)
  end
  dealt_card
end

def initial_deal(deck_of_cards, p_cards, c_cards)
  2.times do
    p_cards << deal_card(deck_of_cards)
    c_cards << deal_card(deck_of_cards)
  end
end

def hit(deck_of_cards, player)
  player << deal_card(deck_of_cards)
end

def display_cards(player, computer)
  system 'clear'
  c_cards = build_card_representations(computer[0, computer.length - 1])
  p_cards = build_card_representations(player[0, player.length - 1])
  last_p_card = build_card_representations([player[-1]]).join
  if computer.length > 2
    prompt "#{COMPUTER} has: #{c_cards.join(', ')}, and unknown card"
  else
    prompt "#{COMPUTER} has: #{c_cards.join(', ')} and unknown card"
  end
  if player.length > 2
    prompt "#{PLAYER} have: #{p_cards.join(', ')}, and #{last_p_card}"
  else
    prompt "#{PLAYER} have: #{p_cards.join(', ')} and #{last_p_card}"
  end
  display_score(player)
end

def display_computer_hand(c_cards)
  copy_cards = build_card_representations(c_cards[0, c_cards.length - 1])
  last_c_card = build_card_representations([c_cards[-1]]).join
  if c_cards.length > 2
    prompt "#{COMPUTER} had: #{copy_cards.join(', ')}, and #{last_c_card}"
  else
    prompt "#{COMPUTER} had: #{copy_cards.join(', ')} and #{last_c_card}"
  end
  prompt "The #{COMPUTER.downcase}'s cards were worth: #{score_cards(c_cards)}"
end

def score_cards(cards)
  score = 0
  cards.sort.each do |card|
    if card == 14
      if score + VALUES[card] > WIN_SCORE
        score += 1
      else
        score += VALUES[card]
      end
    else
      score += VALUES[card]
    end
  end
  score
end

def display_score(player)
  prompt "#{PLAYER}r cards are worth: #{score_cards(player)}"
end

def busted?(cards)
  score_cards(cards) > WIN_SCORE
end

def who_won(player, computer)
  if score_cards(player) > score_cards(computer)
    PLAYER
  else
    COMPUTER
  end
end

def final_result(player, computer)
  if busted?(player)
    prompt "#{PLAYER} busted! The #{COMPUTER.downcase} won."
  elsif busted?(computer)
    prompt "The #{COMPUTER.downcase} busted! #{PLAYER} won!"
    display_computer_hand(computer)
  elsif who_won(player, computer) == PLAYER
    prompt "#{PLAYER} won!"
    display_computer_hand(computer)
  else
    prompt "The #{COMPUTER.downcase} won."
    display_computer_hand(computer)
  end
end

def computer_plays(deck_of_cards, c_cards)
  while score_cards(c_cards) < DEALER_STOP_SCORE
    hit(deck_of_cards, c_cards)
  end
end

def display_rounds_score(p_score, c_score)
  prompt "#{PLAYER}r score: #{p_score}"
  prompt "#{COMPUTER} score: #{c_score}"
end

player_score = 0
computer_score = 0
loop do
  deck = build_deck
  player_cards = []
  computer_cards = []
  initial_deal(deck, player_cards, computer_cards)

  loop do
    display_cards(player_cards, computer_cards)

    loop do
      prompt "Would you like to hit (h) or stay (s)?"
      answer = ''
      loop do
        answer = gets.chomp
        break if answer.downcase.start_with?('h') || answer.downcase.start_with?('s')
        prompt "Please enter a valid choice: 'h' or 's'"
      end

      if answer == 'h'
        hit(deck, player_cards)
        display_cards(player_cards, computer_cards)
        break if busted?(player_cards)
      else
        break
      end
    end

    break if busted?(player_cards)

    computer_plays(deck, computer_cards)

    break if busted?(computer_cards) || who_won(player_cards, computer_cards)
  end

  final_result(player_cards, computer_cards)

  if who_won(player_cards, computer_cards) == PLAYER || busted?(computer_cards)
    player_score += 1
  elsif who_won(player_cards, computer_cards) == COMPUTER || busted?(player_cards)
    computer_score += 1
  end
  display_rounds_score(player_score, computer_score)

  break if player_score == ROUNDS || computer_score == ROUNDS

  prompt "The first one to #{ROUNDS} wins."
  prompt "Would you like to play again? (y or n)"
  play_again = gets.chomp
  break if play_again.downcase != 'y'
end

prompt "Thank you for playing 21! Goodbye."
