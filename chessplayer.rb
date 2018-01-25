require_relative 'chessboard.rb'
require_relative 'chesspieces.rb'

class Player
  attr_accessor :name, :pieces, :from, :to, :chess_piece, :possible_piece

  def initialize(name, pieces=[])
    @name = name
    @pieces = pieces
    @possible_piece = possible_piece
    @from = from
    @to = to
    @chess_piece = ChessPieces.new
  end

  def take_turn_from(options, stdin = $stdin)
    print "\n#{@name}, select the square of the chess piece you want to move(column#, then row#).\n> "
    input1 = stdin.gets.chomp.to_i
    @from = convert_input(input1)
    selected = $board[@from[0]][@from[1]]
    p "counter_k-before: #{$counter_k}"
    p "counter_K-before: #{$counter_K}"
    p valid_moves(selected)

    # verify 1. input is within board, 2. player is selecting their own chess pieces, 3. there are possible moves
    until options.include?(input1) && @pieces.include?(selected) && valid_moves(selected) != [] && valid_moves(selected) != nil
      p "counter_k-middle: #{$counter_k}"
      p "counter_K-middle: #{$counter_K}"
      print "Invalid selection. Try again:\n> "
      input1 = stdin.gets.chomp.to_i
      @from = convert_input(input1)
      p "counter_k-last: #{$counter_k}"
      p "counter_K-last: #{$counter_K}"
      selected = $board[@from[0]][@from[1]]
    end
    convert_input(input1)
  end

  def take_turn_to(options, stdin = $stdin)
    print "\nNow the square where you want to move your chess piece to(column#, then row#).\n> "
    input2 = stdin.gets.chomp.to_i
    @to = convert_input(input2)

    # verify 1. input is w/i board, 2. chess pieces are making valid moves, 3. pieces don't capture their own
    until options.include?(input2) && valid_moves.include?(@to) && !@pieces.include?($board[@to[0]][@to[1]])
      print "Invalid selection. Try again:\n> "
      input2 = stdin.gets.chomp.to_i
      @to = convert_input(input2)
    end

    convert_input(input2)

  #  # en passant
  #  x = @counter_verify
  #  if @counter_verify == x && $move_piece = "p" && from(init pos) && to(en passant pos) && en pas(left or right) == "P"
  #    if @counter_verify == x + 1 && $move_piece && en pas(left) = "P" || en pas(right) = "P"
  #
  #  elsif @counter_verify == x && $move_piece = "P" && from(init pos) && to(en passant pos) && en pas(left or right) == "p"
  #  end

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
    #p $move_piece
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
      if $counter_k == 0
        if from == [4,0] && $board[7][0] == 'r' && $board[5][0] && $board[6][0] == ' ' #&& to == [6,0]
          @chess_piece.king_moves(from, pieces) << [6,0]
        elsif from == [4,0] && $board[0][0] == 'r' && $board[1][0] && $board[2][0] && $board[3][0] == ' ' #&& to == [2,0]
          @chess_piece.king_moves(from, to, pieces) << [2,0]
        else
          @chess_piece.king_moves(from, to, pieces)
        end
      else
        @chess_piece.king_moves(from, to, pieces)
      end
    when movepiece == "K"
      if $counter_K == 0
        if from == [4,7] && $board[7][7] == 'R' && $board[5][7] && $board[6][7] == ' ' #&& to == [6,7]
          @chess_piece.king_moves(from, to, pieces) << [6,7]
        elsif from == [4,7] && $board[0][7] == 'R' && $board[1][7] && $board[2][7] && $board[3][7] == ' ' #&& to == [2,7]
          @chess_piece.king_moves(from, to, pieces) << [2,7]
        else
          @chess_piece.king_moves(from, to, pieces)
        end
      else
        @chess_piece.king_moves(from, to, pieces)
      end
    when movepiece == "p" || movepiece == "P"
      #@counter_p += 1
      @chess_piece.pawn_moves(from, movepiece, pieces)
    end
  end

end
