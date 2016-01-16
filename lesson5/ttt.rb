require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def get_marker(num)
    @squares[num].marker
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def joinor(separator = ",", final_separator = "or")
    unmarked = unmarked_keys
    if unmarked.count == 1
      unmarked.join
    else
      joined_array = unmarked[0, unmarked.length - 1]
      joined_array.insert(-1, (final_separator + " " + unmarked[-1].to_s))
      joined_array.join(separator + " ")
    end
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.uniq.count == 1
  end

  # return winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)      # => we wish this method existed
        return squares.first.marker             # => return the marker, whatever it is
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def update_score
    @score += 1
  end

  def score
    @score
  end
end

class TTTGame
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer, :rounds, :player_marker

  def initialize
    @board = Board.new
    @computer = Player.new(COMPUTER_MARKER)
    @player_marker = get_human_marker
    @human = Player.new(@player_marker)
    @current_marker = @player_marker
    @rounds = rounds_to_play
  end

  def play
    clear('clear')
    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board_full?

        clear_screen_and_display_board
      end

      display_result
      update_results
      display_rounds_score
      break if match_over?
      break unless play_again?
      game_reset
    end

    display_goodbye_message
  end

  private

  def get_human_marker
    puts "Please choose your marker (X, L, etc.). O is the computer."
    answer = nil
    loop do
      answer = gets.chomp
      break unless answer == COMPUTER_MARKER || answer.size > 1
      puts "You must choose one letter/number other than 'O'."
    end
    answer
  end

  def update_results
    if board.someone_won?
      if board.winning_marker == @player_marker
        human.update_score
      elsif board.winning_marker == COMPUTER_MARKER
        computer.update_score
      end
    end
  end

  def rounds_to_play
    display_welcome_message
    puts "How many points would you like to play until?"
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if Integer(answer)
      puts "Please enter a number:"
    end

    @rounds = answer
  end

  def match_over?
    @human.score == @rounds || @computer.score == @rounds
  end

  def display_rounds_score
    puts "You: #{human.score}. Computer: #{computer.score}."
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're an #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear('clear')
    display_board
  end

  def human_moves
    puts "Choose a square between (#{board.joinor}): "
    square = 0
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def computer_moves
    offense = computer_offense
    defense = computer_defense
    if offense
      board[offense] = computer.marker
    elsif defense
      board[defense] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def computer_defense
    Board::WINNING_LINES.each do |winning_combos|
      check_markers = []
      winning_combos.each do |num|
        check_markers << board.get_marker(num)
      end
      if check_markers.count(@player_marker) == 2 && check_markers.count(" ") == 1
        winning_combos.each do |num|
          if board.get_marker(num) == ' '
            return num.to_i
          end
        end
      end
    end
    nil
  end

  def computer_offense
    Board::WINNING_LINES.each do |winning_combos|
      check_markers = []
      winning_combos.each do |num|
        check_markers << board.get_marker(num)
      end
      if check_markers.count(COMPUTER_MARKER) == 2 && check_markers.count(" ") == 1
        winning_combos.each do |num|
          if board.get_marker(num) == ' '
            return num.to_i
          end
        end
      end
    end
    nil
  end

  def board_full?
    board.full?
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again (y/n)?"
      answer = gets.chomp
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear(command)
    system command
  end

  def game_reset
    board.reset
    @current_marker = @player_marker
    clear('clear')
    puts "Let's play again!"
    puts ""
  end

  def current_player_moves
    if @current_marker == @player_marker
      @current_marker = COMPUTER_MARKER
      human_moves
    else
      @current_marker = @player_marker
      computer_moves
    end
  end
end

# we'll kick off the game like this
game = TTTGame.new
game.play
