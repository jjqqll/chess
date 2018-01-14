require_relative 'chessboard.rb'

class ChessPieces
  attr_accessor :r, :R, :n, :N, :b, :B, :q, :Q, :k, :K, :p, :P

  def initialize
    @r = 'r'
    @R = 'R'
    @n = 'n'
    @N = 'N'
    @b = 'b'
    @B = 'B'
    @q = 'q'
    @Q = 'Q'
    @k = 'k'
    @K = 'K'
    @p = 'p'
    @P = 'P'
  end

  def knight_moves(from_square=[0,0])
    # the knight's 8 possible moves from a position, provided that the move does not go off the ChessBoard
    moves = [[+1, +2], [+2, +1], [+2, -1], [+1, -2], [-1, -2], [-2, -1], [-2, +1], [-1, +2]]

    # valid_positions are positions after making valid 'moves' within the ChessBoard
    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
      valid_positions << potential_position #if on_board(potential_position)
      end
    valid_positions.map { |x| x.join }
  end

#  def on_board(position) # checks if position is within the ChessBoard
#    position[0].between?(0,7) && position[1].between?(0,7) ? true : false
#  end
end
