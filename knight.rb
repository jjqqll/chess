require_relative 'chessboard.rb'

class Knight
  # creates a game board and a knight. the squares on the game ChessBoard
  # can be represented as positions/nodes, further represented as parent, children
  attr_accessor :position, :parent

  def initialize(position=nil, parent=nil)
    @position = position
    @parent = parent
  end

  def possible_moves(position)
    # the knight's 8 possible moves from a position, provided that the move does not go off the ChessBoard
    moves = [[+1, +2], [+2, +1], [+2, -1], [+1, -2], [-1, -2], [-2, -1], [-2, +1], [-1, +2]]

    # valid_positions are positions after making valid 'moves' within the ChessBoard
    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [position[0] + move[0], position[1] + move[1]]
      valid_positions << potential_position if GameBoard.new.on_board(potential_position)
      end
    valid_positions
  end

#  def on_board(position) # checks if position is within the ChessBoard
#    position[0].between?(0,7) && position[1].between?(0,7) ? true : false
#  end

end

test = Knight.new
test.possible_moves([6,6])
