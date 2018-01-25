require_relative 'chessplayer.rb'
require_relative 'chesspieces.rb'

class GameBoard
  attr_accessor :board, :player1, :player2, :move_piece, :set_board, :from_square, :to_square, :turn_number, :options, :wp_promotion_rank, :bp_promotion_rank

  def initialize(name1 = "Player 1", name2 = "Player 2")
    $board = Array.new(8) { Array.new(8, ' ') }
    @player1 = Player.new(name1, ['r', 'n', 'b', 'q', 'k', 'p'])
    @player2 = Player.new(name2, ['R', 'N', 'B', 'Q', 'K', 'P'])
    @from_square = from_square
    @to_square = to_square
    $move_piece = move_piece
    @set_board = set_board
    @turn_number = 1
    @options = [0, 1, 2, 3, 4, 5, 6, 7].repeated_permutation(2).to_a.map {|x| x.join.to_i}
    @wp_promotion_rank = [[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]]
    @bp_promotion_rank = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
    $counter_k = 0
    $counter_K = 0
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
    $move_piece = $board[from_square[0]][from_square[1]]
    @to_square = player.take_turn_to(@options)
    castling
    delete_disc(player, from_square[0], from_square[1])
    add_disc(player, to_square[0], to_square[1])

  end

  def delete_disc(player=nil, from_square1, from_square2)
    $board[from_square1][from_square2] = " "
  end

  def add_disc(player=nil, to_square1, to_square2)
    # pawn promotion
    if $move_piece == "p" && @wp_promotion_rank.include?(@to_square)
      print "\n What would you like to promote your pawn to? queen, rook, bishop or knight? "
      input3 = $stdin.gets.chomp
      input3
      until player.pieces.include?(input3)
        print "That is an incorrect value! Try again:\n"
        input3 = $stdin.gets.chomp
      end
      $board[to_square[0]][to_square[1]] = input3

    elsif $move_piece == "P" && @bp_promotion_rank.include?(to_square)
      print "\n What would you like to promote your pawn to? queen, rook, bishop or knight? "
      input3 = $stdin.gets.chomp

      until player.pieces.include?(input3)
        print "That is an incorrect value! Try again:\n"
        input3 = $stdin.gets.chomp
      end
      $board[to_square[0]][to_square[1]] = input3

    else
    $board[to_square1][to_square2] = $move_piece
    end
  end

  def castling
    if $move_piece == "k" || $move_piece == "r"
      castling_k
    elsif $move_piece == "K" || $move_piece == "R"
      castling_K
    end
  end

  def castling_k
    if $counter_k == 0
      case
      when $move_piece == "k" && $board[4][0] == 'k' && to_square == [6,0] && $board[7][0] == 'r' && $board[5][0] && $board[6][0] == ' '
        $board[5][0] = 'r'
        $board[7][0] = ' '
        $counter_k += 1
      when $move_piece == "k" && $board[4][0] == 'k' && to_square == [2,0] && $board[0][0] == 'r' && $board[1][0] && $board[2][0] && $board[3][0] == ' '
        $board[3][0] = 'r'
        $board[0][0] = ' '
        $counter_k += 1
      else
        $counter_k += 1
      end
    end
  end

  def castling_K
    if $counter_K == 0
      case
      when $move_piece == "K" && $board[4][7] == 'K' && to_square == [6,7] && $board[7][7] == 'R' && $board[5][7] && $board[6][7] == ' '
        $board[5][7] = 'R'
        $board[7][7] = ' '
        $counter_K += 1
      when $move_piece == "K" && $board[4][7] == 'K' && to_square == [2,7] && $board[0][7] == 'R' && $board[1][7] && $board[2][7] && $board[3][7] == ' '
        $board[3][7] = 'R'
        $board[0][7] = ' '
        $counter_K += 1
      else
        $counter_K += 1
      end
    end
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
