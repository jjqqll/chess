require_relative 'chessplayer.rb'
require_relative 'chesspieces.rb'

class GameBoard
  attr_accessor :board, :player1, :player2, :move_piece, :set_board, :turn_number, :options

  def initialize(name1 = "Player 1", name2 = "Player 2")
    $board = Array.new(8) { Array.new(8, ' ') }
    @player1 = Player.new(name1, ['r', 'n', 'b', 'q', 'k', 'p'])
    @player2 = Player.new(name2, ['R', 'N', 'B', 'Q', 'K', 'P'])
    @move_piece = move_piece
    @set_board = set_board
    @turn_number = 1
    @options = [0, 1, 2, 3, 4, 5, 6, 7].repeated_permutation(2).to_a.map {|x| x.join.to_i}
  end

  def play
    puts display
    set_board
    instructions
    turns
  end

  def display
    display_string = ''

    7.downto(0) do |row|
      display_string << "+---+---+---+---+---+---+---+---+ \n"
      0.upto(7) do |column|
          display_string << "| #{$board[column][row]} "
      end
      display_string << "|#{row}\n"
    end

    display_string << "+---+---+---+---+---+---+---+---+ \n"
    display_string << '  0   1   2   3   4   5   6   7  '

    puts display_string
  end

  def set_board
    $board[0][0] = "r"; $board[0][1] = "p"; $board[0][6] = "P"; $board[0][7] = "R";
    $board[1][0] = "n"; $board[1][1] = "p"; $board[1][6] = "P"; $board[1][7] = "N";
    $board[2][0] = "b"; $board[2][1] = "p"; $board[2][6] = "P"; $board[2][7] = "B";
    $board[3][0] = "q"; $board[3][1] = "p"; $board[3][6] = "P"; $board[3][7] = "Q";
    $board[4][0] = "k"; $board[4][1] = "p"; $board[4][6] = "P"; $board[4][7] = "K";
    $board[5][0] = "b"; $board[5][1] = "p"; $board[5][6] = "P"; $board[5][7] = "B";
    $board[6][0] = "n"; $board[6][1] = "p"; $board[6][6] = "P"; $board[6][7] = "N";
    $board[7][0] = "r"; $board[7][1] = "p"; $board[7][6] = "P"; $board[7][7] = "R";

  end

  def instructions
    print "\nWelcome to Chess!  The player with the white(lower cases) pieces moves first.\n"
  end

#  def on_board(position=[0,0]) # checks if position is within the ChessBoard
#    position[0].between?(0,7) && position[1].between?(0,7) ? true : false
#  end

  def turns
    won = false
    draw = false
    until draw #|| won
      turn
      display
      @turn_number += 1
      if @turn_number == 1
        set_board
      end
      #draw = check_for_draw
      #won = check_for_win
    end
    won ? win : draw
  end

  def turn
    player = @turn_number.even? ? @player2 : @player1
    from_square = player.take_turn_from(@options)
    @move_piece = $board[from_square[0]][from_square[1]]
    to_square = player.take_turn_to(@options)
    delete_disc(player, from_square[0], from_square[1])
    add_disc(player, to_square[0], to_square[1])
  end

  def delete_disc(player=nil, from_square1, from_square2)
    $board[from_square1][from_square2] = " "
  end

  def add_disc(player=nil, to_square1, to_square2)
    $board[to_square1][to_square2] = @move_piece
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
