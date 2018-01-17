require_relative 'chessboard.rb'
require_relative 'chessplayer.rb'

class ChessPieces

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
    valid_positions
  end

  def king_moves(from_square=[0,0])
    moves = [[+1, +0], [+1, -1], [+0, -1], [-1, -1], [-1, +0],
    [-1, +1], [+0, +1], [+1, +1]]

    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
      valid_positions << potential_position
    end
    valid_positions
  end

  def rook_moves(from_square=[0,0], to_square=[0,0])
    moves = [[+0, +1], [+0, +2], [+0, +3], [+0, +4], [+0, +5], [+0, +6], [+0, +7],
    [+0, -1], [+0, -2], [+0, -3], [+0, -4], [+0, -5], [+0, -6], [+0, -7],
    [+1, +0], [+2, +0], [+3, +0], [+4, +0], [+5, +0], [+6, +0], [+7, +0],
    [-1, +0], [-2, +0], [-3, +0], [-4, +0], [-5, +0], [-6, +0], [-7, +0]]

    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
      valid_positions << potential_position #if potential_position is not blocked(all squares before [to_square] are empty)
    end
    valid_positions
  end

  def bishop_moves(from_square=[0,0])
    moves = [[+1, +1], [+2, +2], [+3, +3], [+4, +4], [+5, +5], [+6, +6], [+7, +7],
    [+1, -1], [+2, -2], [+3, -3], [+4, -4], [+5, -5], [+6, -6], [+7, -7],
    [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
    [-1, +1], [-2, +2], [-3, +3], [-4, +4], [-5, +5], [-6, +6], [-7, +7]]

    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
      valid_positions << potential_position #if potential_position is not blocked
    end
    valid_positions
  end

  def queen_moves(from_square=[0,0])
    moves = [[+1, +1], [+2, +2], [+3, +3], [+4, +4], [+5, +5], [+6, +6], [+7, +7],
    [+1, -1], [+2, -2], [+3, -3], [+4, -4], [+5, -5], [+6, -6], [+7, -7],
    [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
    [-1, +1], [-2, +2], [-3, +3], [-4, +4], [-5, +5], [-6, +6], [-7, +7],
    [+0, +1], [+0, +2], [+0, +3], [+0, +4], [+0, +5], [+0, +6], [+0, +7],
    [+0, -1], [+0, -2], [+0, -3], [+0, -4], [+0, -5], [+0, -6], [+0, -7],
    [+1, +0], [+2, +0], [+3, +0], [+4, +0], [+5, +0], [+6, +0], [+7, +0],
    [-1, +0], [-2, +0], [-3, +0], [-4, +0], [-5, +0], [-6, +0], [-7, +0]]

    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
      valid_positions << potential_position # if potential_position is not blocked
    end
    valid_positions
  end

  def pawn_moves(from_square=[0,0])
    wp_init_postions = [[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]]
    bp_init_postions = [[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6]]

    moves = []
    if $move_piece == "p" && wp_init_postions.include?(from_square)
      moves = [[+0, +1], [+0, +2]]
    elsif $move_piece == "p" && !wp_init_postions.include?(from_square)
      moves = [[+0, +1]]
    elsif $move_piece == "P" && bp_init_postions.include?(from_square)
      moves = [[+0, -1], [+0, -2]]
    elsif $move_piece == "P" && !bp_init_postions.include?(from_square)
      moves = [[+0, -1]]
    end

    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
      valid_positions << potential_position # if potential_position is not blocked
    end
    valid_positions
  end

  def pawn_promotion(to=[0,0])
    print "\n What would you like to promote your pawn to? queen, rook, bishop or knight?"

  end
#  def on_board(position) # checks if position is within the ChessBoard
#    position[0].between?(0,7) && position[1].between?(0,7) ? true : false
#  end
end
