class Player
  attr_accessor :move, :name

  def initialize
    set_name
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
      puts "Please choose: #{CHOICES.join(', ')}"
      choice = gets.chomp
      break if CHOICES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = choice
  end
end

class Computer < Player
  CHOICES = %w(Rock Paper Scissors)
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = CHOICES.sample
  end
end

class RPSGame
  attr_accessor :human, :computer
  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_winner
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."

    case human.move
    when "Rock"
      puts "It's a tie!" if computer.move == "Rock"
      puts "#{human.name} won!" if computer.move == "Scissors"
      puts "#{computer.name} won!" if computer.move == "Paper"
    when "Paper"
      puts "It's a tie!" if computer.move == "Paper"
      puts "#{human.name}  won!" if computer.move == "Rock"
      puts "#{computer.name} won!" if computer.move == "Scissors"
    when "Scissors"
      puts "It's a tie!" if computer.move == "Scissors"
      puts "#{human.name}  won!" if computer.move == "Paper"
      puts "#{computer.name} won!" if computer.move == "Rock"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return true if answer == 'y'
    return false
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
