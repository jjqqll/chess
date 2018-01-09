require_relative 'chessplayer.rb'

class GameBoard
  attr_accessor :board, :player1, :player2, :on_board, :turn_number, :options

  def initialize(name1 = "Player 1", name2 = "Player 2")
    @board = Array.new(8) { Array.new(8, ' ') }
    @player1 = Player.new(name1, '☺')
    @player2 = Player.new(name2, '☻')
    @on_board = on_board
    @turn_number = 1
    @options = [0, 1, 2, 3, 4, 5, 6, 7].repeated_permutation(2).to_a.map {|x| x.join.to_i}
  end

  def play
    puts display
    instructions
    turns
  end

  def display
    pieces = %w{r n b q k b n r R N B Q K B N R}
    display_string = ''

    7.downto(0) do |row|
      display_string << "+---+---+---+---+---+---+---+---+ \n"
      0.upto(7) do |column|
        if row == 0
          display_string << "| #{@board[column][row] = pieces.pop} "
        elsif row == 1
          display_string << "| #{@board[column][row] = 'p'} "
        elsif row == 6
          display_string << "| #{@board[column][row] = 'P'} "
        elsif row == 7
            display_string << "| #{@board[column][row] = pieces.pop} "
        else
          display_string << "| #{@board[column][row]} "
        end
      end
      display_string << "|#{row}\n"
    end

    display_string << "+---+---+---+---+---+---+---+---+ \n"
    display_string << '  0   1   2   3   4   5   6   7  '

    puts display_string
  end

  def instructions
    print "\nWelcome to Chess!  The player with the white(lower cases) pieces moves first.\n"
  end

  def on_board(position=[0,0]) # checks if position is within the ChessBoard
    position[0].between?(0,7) && position[1].between?(0,7) ? true : false
  end

  def turns
    won = false
    draw = false
    until draw || won
      turn
      @turn_number += 1
      display
      #draw = check_for_draw
      won = check_for_win
    end
    won ? win : draw
  end

  def turn
    player = @turn_number.even? ? @player2 : @player1
    chosen_square = player.take_turn(@options) - 1
    add_disc(player, chosen_square)
  end

  def add_disc(player, column)
    i = 0
    until @board[column][i] == " " # go to the lowest empty cell in that column
      i += 1
    end
    @board[column][i] = player.disc
    @options.delete(column + 1) if i == 5 # delete column from @options when all cells in column is filled
  end

  def check_for_win
    return true if check_horizontal_wins || check_vertical_wins || check_diagonal_wins
    false
  end

  def check_horizontal_wins
    0.upto(5) do |y|
      0.upto(3) do |x|
        return true if @board[x][y] != ' ' && @board[x][y] == @board[x+1][y] && @board[x+1][y] == @board[x+2][y] && @board[x+2][y] == @board[x+3][y]
      end
    end
    false
  end

  def check_vertical_wins
    0.upto(6) do |x|
      0.upto(2) do |y|
        return true if @board[x][y] != ' ' && @board[x][y] == @board[x][y+1] && @board[x][y+1] == @board[x][y+2] && @board[x][y+2] == @board[x][y+3]
      end
    end
    false
  end

  def check_diagonal_wins
    0.upto(3) do |x|
      0.upto(2) do |y|
        return true if @board[x][y] != ' ' && @board[x][y] == @board[x+1][y+1] && @board[x+1][y+1] == @board[x+2][y+2] && @board[x+2][y+2] == @board[x+3][y+3]
      end

      3.upto(5) do |y|
        return true if @board[x][y] != ' ' && @board[x][y] == @board[x+1][y-1] && @board[x+1][y-1] == @board[x+2][y-2] && @board[x+2][y-2] == @board[x+3][y-3]
      end
    end
    false
  end

  def win
    winner = @turn_number.even? ? @player1.name : @player2.name
    puts "Congratulations #{winner}, you won!"
  end

  def draw
    puts "Good game players.  That's a draw!"
  end
end
