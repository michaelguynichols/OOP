# rpsls_game.rb
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
  VALUES = %w(r p s l S)
  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 's'
  end

  def rock?
    @value == 'r'
  end

  def paper?
    @value == 'p'
  end

  def lizzard?
    @value == 'l'
  end

  def spock?
    @value == 'S'
  end

  def >(other_move)
    if rock?
      other_move.scissors? || other_move.lizzard?
    elsif paper?
      other_move.rock? || other_move.spock?
    elsif scissors?
      other_move.paper? || other_move.lizzard?
    elsif lizzard?
      other_move.spock? || other_move.paper?
    elsif spock?
      other_move.scissors? || other_move.rock?
    end
  end

  def <(other_move)
    if rock?
      other_move.paper? || other_move.spock?
    elsif paper?
      other_move.scissors? || other_move.lizzard?
    elsif scissors?
      other_move.rock? || other_move.spock?
    elsif lizzard?
      other_move.scissors? || other_move.rock?
    elsif spock?
      other_move.lizzard? || other_move.paper?
    end
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = Score.new
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

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  CHOICES_INTO_WORDS = { "r" => "rock", "p" => "paper", "s" => "scissors", "l" => "lizard", "S" => "Spock" }
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
    puts "#{determine_winner.name} won the match! Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{CHOICES_INTO_WORDS[human.move.to_s]}."
    puts "#{computer.name} chose #{CHOICES_INTO_WORDS[computer.move.to_s]}."
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
        computer.choose
        display_moves
        display_winner
        winner = determine_winner
        if winner
          winner.score.update
        end
        display_score
        break if rounds.match_over?(human, computer)
        break unless play_again?
      end
      break
    end
    display_goodbye_message
  end
end

RPSGame.new.play
