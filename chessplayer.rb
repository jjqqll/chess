require_relative 'chessboard.rb'
require_relative 'chesspieces.rb'

class Player
  attr_accessor :name, :pieces, :from, :to, :chess_piece, :possible_piece

  def initialize(name, pieces=[])
    @name = name
    @pieces = pieces
    @from = from
    @to = to
    @chess_piece = ChessPieces.new
    @possible_piece = possible_piece
  end

  def take_turn_from(options, stdin = $stdin)
    print "\n#{@name}, choose FROM(column#, then row#).\n> "
    input1 = stdin.gets.chomp.to_i
    @from = convert_input(input1)
    selected = $board[@from[0]][@from[1]]

    # verify 1. input is within board, 2. player is selecting their own chess pieces, 3. there are possible moves, 4. moving will not put own king in check
    until options.include?(input1) && @pieces.include?(selected) && valid_moves(selected) != [] && valid_moves(selected) != nil# && check(@from) == false
      print "Invalid selection. Try again:\n> "
      input1 = stdin.gets.chomp.to_i
      @from = convert_input(input1)
      selected = $board[@from[0]][@from[1]]
    end
    p valid_moves(selected)
    convert_input(input1)
  end

  def take_turn_to(options, stdin = $stdin)
    print "\nNow where TO?(column#, then row#).\n> "
    input2 = stdin.gets.chomp.to_i
    @to = convert_input(input2)

    # verify 1. input is w/i board, 2. chess pieces are making valid moves, 3. pieces don't capture their own, 4. move doesn't put own king in check
    until options.include?(input2) && valid_moves.include?(@to) && !@pieces.include?($board[@to[0]][@to[1]]) #&& check(@to) == false unless
      print "Invalid selection. Try again:\n> "
      input2 = stdin.gets.chomp.to_i
      @to = convert_input(input2)
    end

    convert_input(input2)
  end

  def convert_input(input)
    if input.to_s.length == 1
      input = input.to_s.rjust(2, "0").split("").collect { |x| x.to_i }
    else
      input = input.to_s.split("").collect { |x| x.to_i }
    end
    input
  end

  def valid_moves(movepiece=$move_piece)
    case
    when movepiece == "r" || movepiece == "R"
      @chess_piece.rook_moves(from, pieces)
    when movepiece == "n" || movepiece == "N"
      @chess_piece.knight_moves(from, pieces)
    when movepiece == "b" || movepiece == "B"
      @chess_piece.bishop_moves(from, pieces)
    when movepiece == "q" || movepiece == "Q"
      @chess_piece.queen_moves(from, pieces)
    when movepiece == "k"
      moves_of_k
    when movepiece == "K"
      moves_of_K
    when movepiece == "p" || movepiece == "P"
      @chess_piece.pawn_moves(from, movepiece, pieces)
    end
  end

  def moves_of_k
    if $counter_k == 0
      if from == [4,0] && $board[7][0] == 'r' && $board[5][0] && $board[6][0] == ' '
        @chess_piece.king_moves(from, pieces) << [6,0]
      elsif from == [4,0] && $board[0][0] == 'r' && $board[1][0] && $board[2][0] && $board[3][0] == ' '
        @chess_piece.king_moves(from, pieces) << [2,0]
      else
        @chess_piece.king_moves(from, pieces)
      end
    else
      @chess_piece.king_moves(from, pieces)
    end
  end

  def moves_of_K
    if $counter_K == 0
      if from == [4,7] && $board[7][7] == 'R' && $board[5][7] && $board[6][7] == ' '
        @chess_piece.king_moves(from, pieces) << [6,7]
      elsif from == [4,7] && $board[0][7] == 'R' && $board[1][7] && $board[2][7] && $board[3][7] == ' '
        @chess_piece.king_moves(from, pieces) << [2,7]
      else
        @chess_piece.king_moves(from, pieces)
      end
    else
      @chess_piece.king_moves(from, pieces)
    end
  end

  def king_position
    king = pieces.include?("k") ? "k" : "K"

    0.upto(7) do |x|
      0.upto(7) do |y|
        return king_position = [x, y] if $board[x][y] == king
      end
    end
  end

  def check(from=@from) # if moved, you will put your own king in check

    opponent_pieces = pieces.include?("k") ? ["R", "N", "B", "Q", "K", "P"] : ["r", "n", "b", "q", "k", "p"]
    from_piece = $board[@from[0]][@from[1]] # save piece in order to add it back at the end
    $board[@from[0]][@from[1]] = " " # delete piece first in order to find out if opponent_capture_positions include your king
    check = []
    0.upto(7) do |x|
      0.upto(7) do |y|
        # select opponent's pieces
        opponent_piece = $board[x][y] if opponent_pieces.include?($board[x][y])
        # to see if opponent piece's capture positions include your king's position
        case
          when opponent_piece == "r" || opponent_piece == "R"
            opponent_capture_positions = @chess_piece.rook_moves([x,y], opponent_pieces)
          when opponent_piece == "n" || opponent_piece == "N"
            opponent_capture_positions = @chess_piece.knight_moves([x,y], opponent_pieces)
          when opponent_piece == "b" || opponent_piece == "B"
            opponent_capture_positions = @chess_piece.bishop_moves([x,y], opponent_pieces)
          when opponent_piece == "q" || opponent_piece == "Q"
            opponent_capture_positions = @chess_piece.queen_moves([x,y], opponent_pieces)
          when opponent_piece == "k"
            opponent_capture_positions =
            if $counter_k == 0
              if [x,y] == [4,0] && $board[7][0] == 'r' && $board[5][0] && $board[6][0] == ' '
                @chess_piece.king_moves([x,y], opponent_pieces) << [6,0]
              elsif [x,y] == [4,0] && $board[0][0] == 'r' && $board[1][0] && $board[2][0] && $board[3][0] == ' '
                @chess_piece.king_moves([x,y], opponent_pieces) << [2,0]
              else
                @chess_piece.king_moves([x,y], opponent_pieces)
              end
            else
              @chess_piece.king_moves([x,y], opponent_pieces)
            end
          when opponent_piece == "K"
            opponent_capture_positions =
            if $counter_K == 0
              if [x,y] == [4,7] && $board[7][7] == 'R' && $board[5][7] && $board[6][7] == ' '
                @chess_piece.king_moves([x,y], opponent_pieces) << [6,7]
              elsif [x,y] == [4,7] && $board[0][7] == 'R' && $board[1][7] && $board[2][7] && $board[3][7] == ' '
                @chess_piece.king_moves([x,y], opponent_pieces) << [2,7]
              else
                @chess_piece.king_moves([x,y], opponent_pieces)
              end
            else
              @chess_piece.king_moves([x,y], opponent_pieces)
            end
          when opponent_piece == "p" || opponent_piece == "P"
            opponent_capture_positions = @chess_piece.pawn_moves([x,y], opponent_piece, opponent_pieces)
        end
        check << opponent_capture_positions if opponent_capture_positions != nil && opponent_capture_positions != []
      end
    end
    $board[@from[0]][@from[1]] = from_piece
    check.flatten(1).include?(king_position) ? true : false
  end

end
