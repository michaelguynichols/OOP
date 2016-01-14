# rps_game.rb
require 'pry'

class Rounds
  attr_accessor :rounds
  def initialize
    @rounds = get_rounds
  end

  def get_rounds
    round = 0
    loop do
      puts "How many points would you like to play to?"
      round = gets.chomp
      break if valid_number?(round)
      puts "Please enter a number."
    end
    round.to_i
  end

  def valid_number?(num)
    Integer(num) rescue false
  end

  def match_over?(player, computer)
    player.score == rounds || computer.score == rounds
  end
end

class Score
  attr_accessor :score
  def initialize
    @score = 0
  end

  def update
    @score += 1
  end

  def ==(compare)
    score == compare
  end

  def to_s
    "#{score}"
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']
  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    if rock?
      other_move.scissors?
    elsif paper?
      other_move.rock?
    elsif scissors?
      other_move.paper?
    end
  end

  def <(other_move)
    if rock?
      other_move.paper?
    elsif paper?
      other_move.scissors?
    elsif scissors?
      other_move.rock?
    end
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = Score.new
    @history = []
  end

  def add_to_history
    history << self.move
  end

  def history
    @history
  end

  def build_history
    move_count = {}
    history.each do |mv|
      str_mv = mv.to_s
      if move_count.has_key?(str_mv)
        move_count[str_mv] = move_count[str_mv] + 1
      else
        move_count[str_mv] = 1
      end
    end
    move_count
  end

  def calculate_history
    move_percents = {}
    hist_count = build_history
    total = hist_count.values.inject{|sum,x| sum + x }
    hist_count.each do |mv, count|
      move_percents[mv] = Float(count) / Float(total)
    end
    move_percents
  end

  def max_in_history
    history = calculate_history
    max_move = ''
    max_percent = 0
    history.each do |move, percent|
      if percent > max_percent
        max_percent = percent
        max_move = move
      end
    end
    max_move
  end
end

class Human < Player
  CHOICES = %w(Rock Paper Scissors)
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose: #{Move::VALUES.join(', ')}"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose(player)
    self.move = adapt_to_history(player)
  end

  def adapt_to_history(player)
    max_move = player.max_in_history
    final_move = ''
    loop do
      final_move = Move.new(Move::VALUES.sample)
      break if final_move.to_s != max_move.to_s
    end
    final_move
  end
end

class RPSGame
  attr_accessor :human, :computer, :rounds
  def initialize
    @human = Human.new
    @computer = Computer.new
    @rounds = 0
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "#{determine_winner.name} won the match! Thanks for playing Rock, Paper, Scissors. Goodbye!" rescue puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def determine_winner
    if human.move > computer.move
      human
    elsif human.move < computer.move
      computer
    end
  end

  def display_score
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def update_history
    human.add_to_history
    computer.add_to_history
  end

  def display_history
    puts "#{human.name}'s move history: #{human.history.join(', ')}"
    puts "#{computer.name}'s move history: #{computer.history.join(', ')}"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def play_to
    self.rounds = Rounds.new
  end

  def play
    display_welcome_message
    play_to

    loop do
      loop do
        human.choose
        computer.choose(human)
        display_moves
        display_winner
        winner = determine_winner
        if winner
          winner.score.update
        end
        display_score
        update_history
        display_history
        break if rounds.match_over?(human, computer)
        break unless play_again?
      end
      break
    end
    display_goodbye_message
  end
end

RPSGame.new.play
