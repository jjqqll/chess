require_relative 'chessboard.rb'
require_relative 'chessplayer.rb'

class ChessPieces

  def knight_moves(from_square=[0,0], pieces=[])
    # the knight's 8 possible moves from a position
    moves = [[+1, +2], [+2, +1], [+2, -1], [+1, -2], [-1, -2], [-2, -1], [-2, +1], [-1, +2]]

    # valid_positions are positions after making valid 'moves'.
    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
      # verify if w/i board & does not include own chess piece
      valid_positions << potential_position if on_board(potential_position) && !pieces.include?($board[potential_position[0]][potential_position[1]])
      end
    valid_positions
  end


  def king_moves(from_square=[0,0], pieces=[])
    moves = [[+1, +0], [+1, -1], [+0, -1], [-1, -1], [-1, +0],
    [-1, +1], [+0, +1], [+1, +1]]

    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
      # verify if w/i board & does not include own chess piece
      valid_positions << potential_position if on_board(potential_position) && !pieces.include?($board[potential_position[0]][potential_position[1]])
    end
    valid_positions
  end

  def rook_moves(from_square=[0,0], pieces=[])
    moves = [[0, +1], [0, -1], [+1, 0], [-1, 0]]

    valid_positions = []
    potential_positions = []

    moves.each do |move|
     x = from_square[0]
     y = from_square[1]
     loop do  # loop through each possible square. starting at 'from_square', between 0 and 7.
       x += move[0]
       y += move[1]
       if x.between?(0,7) == false # make sure square is w/i board
         break
       elsif y.between?(0,7) == false
         break
       elsif $board[x][y] == " "  # select if square is empty
         potential_positions << [x,y]
       elsif pieces.include?($board[x,y]) # stop when blocked by own chess piece
         break
       else !pieces.include?($board[x,y]) # stop when blocked(but include it because blocking piece is the oppenent)
         potential_positions << [x,y]
         break
       end
     end
    end
    # verify if w/i board & does not include own chess piece
    valid_positions = potential_positions.select { |position| on_board(position) && !pieces.include?($board[position[0]][position[1]]) }

  end

  def bishop_moves(from_square=[0,0], pieces=[])
    moves = [[+1, +1], [+1, -1], [-1, -1], [-1, +1]]

    valid_positions = []
    potential_positions = []

    moves.each do |move|
     x = from_square[0]
     y = from_square[1]
     loop do  # loop through each possible square. starting at 'from_square', between 0 and 7.
       x += move[0]
       y += move[1]
       if x.between?(0,7) == false # make sure square is w/i board
         break
       elsif y.between?(0,7) == false
         break
       elsif $board[x][y] == " "  # select if square is empty
         potential_positions << [x,y]
       elsif pieces.include?($board[x,y]) # stop when blocked by own chess piece
         break
       else !pieces.include?($board[x,y]) # stop when blocked(but include it because blocking piece is the oppenent)
         potential_positions << [x,y]
         break
       end
     end
    end

    # verify if w/i board & does not include own chess piece
    valid_positions = potential_positions.select { |position| on_board(position) && !pieces.include?($board[position[0]][position[1]]) }
  end

  def queen_moves(from_square=[0,0], pieces=[])
    rook_moves(from_square, pieces) + bishop_moves(from_square, pieces)
  end

  def pawn_moves(from_square=[0,0], movepiece="", pieces=[])
    moves = []
    if movepiece == "p"
      moves += wp_moves(from_square, pieces)
    else
      moves += bp_moves(from_square, pieces)
    end
    moves
  end

  def wp_moves(from_square=[0,0], pieces)
    wp_init_positions, wp_passant_positions = [], []
    0.upto(7) {|x| wp_init_positions << [x,1]}
    0.upto(7) {|x| wp_passant_positions << [x,4]}

    x, y = from_square[0], from_square[1]
    if wp_init_positions.include?(from_square)
      one_step(x, y, 1, pieces) | two_step(x, y, 2)
    elsif wp_passant_positions.include?(from_square)
      one_step(x, y, 1, pieces) | passant_diagonal(x, y, 1, pieces, "P")
    else
      one_step(x, y, 1, pieces)
    end
  end

  def bp_moves(from_square=[0,0], pieces)
    bp_init_positions, bp_passant_positions = [], []
    0.upto(7) {|x| bp_init_positions << [x,6]}
    0.upto(7) {|x| bp_passant_positions << [x,3]}

    x, y = from_square[0], from_square[1]
    if bp_init_positions.include?(from_square)
      one_step(x, y, -1, pieces) | two_step(x, y, -2)
    elsif bp_passant_positions.include?(from_square)
      one_step(x, y, -1, pieces) | passant_diagonal(x, y, -1, pieces, "p")
    else
      one_step(x, y, -1, pieces)
    end
  end

  def passant_diagonal(x, y, a, pieces, pawn)
    left_square = $board[x-1][y] if x.between?(1,7)
    right_square = $board[x+1][y] if x.between?(0,6)

    moves = []
    moves << [x+1, y+a] if on_board([x+1, y+a]) && !pieces.include?($board[x+1][y+a]) && right_square == pawn
    moves << [x-1, y+a] if on_board([x-1, y+a]) && !pieces.include?($board[x-1][y+a]) && left_square == pawn
    moves
  end

  def one_step(x, y, a, pieces)
    moves = []
    moves << [x, y + a] if on_board([x, y + a]) && $board[x][y+a] == " "
    moves << [x+1, y+a] if on_board([x+1, y + a]) && !pieces.include?($board[x+1][y+a]) && $board[x+1][y+a] != " "
    moves << [x-1, y+a] if on_board([x-1, y + a]) && !pieces.include?($board[x-1][y+a]) && $board[x-1][y+a] != " "
    moves
  end

  def two_step(x, y, a)
    moves = []
    moves << [x, y + a] if on_board([x, y + a]) && $board[x][y+a] == " " && $board[x][y+a/2] == " "
    moves
  end

  def on_board(from_square=[0,0])
    from_square[0].between?(0,7) && from_square[1].between?(0,7) ? true : false
  end

end
