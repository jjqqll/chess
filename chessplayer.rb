require_relative 'chessboard.rb'
require_relative 'chesspieces.rb'

class Player
  attr_accessor :name, :pieces, :from, :to, :chess_piece

  def initialize(name, pieces=[])
    @name = name
    @pieces = pieces
    @from = from
    @to = to
    @chess_piece = ChessPieces.new
  end

  def take_turn_from(options, stdin = $stdin)
    print "\n#{@name}, select the chess piece you want to move by selecting the square it currently occupies(column# first, then row#).\n> "
    input1 = stdin.gets.chomp.to_i
    @from = convert_input(input1)

    until options.include?(input1) && @pieces.include?($board[@from[0]][@from[1]])
      print "That is an incorrect value! Try again:\n> "
      input1 = stdin.gets.chomp.to_i
      @from = convert_input(input1)
    end
    convert_input(input1)
  end

  def take_turn_to(options, stdin = $stdin)
    print "\n#{@name}, select the square where you want to move your chess piece to(column# first, then row#).\n> "
    input2 = stdin.gets.chomp.to_i
    @to = convert_input(input2)

    until options.include?(input2) && valid_moves.include?(input2.to_s) && !@pieces.include?($board[@to[0]][@to[1]])
      print "That is an incorrect value! Try again:\n> "
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

  def valid_moves
    #if @move_piece == "n" || @move_piece == "N"
      @chess_piece.knight_moves(from)
    #end
  end

end
