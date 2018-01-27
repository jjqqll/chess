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
    moves = [[+1, +1], [+1, -1], [-1, -1], [-1, +1],
    [+0, +1], [+0, -1], [+1, +0], [-1, +0]]

    valid_positions = []
    potential_positions = []

    moves.each do |move|
     x = from_square[0]
     y = from_square[1]
     loop do  # loop through each possible square. starting at 'from_square', between 0 and 7.
       x += move[0]
       y += move[1]
       if pieces.include?($board[x,y]) # stop when blocked by own chess piece
         break
       elsif x.between?(0,7) == false # make sure square is w/i board
         break
       elsif y.between?(0,7) == false
         break
       elsif $board[x][y] == " "  # select if square is empty
         potential_positions << [x,y]
       elsif !pieces.include?($board[x,y]) # stop when blocked(but include it because blocking piece is the oppenent)
         potential_positions << [x,y]
         break
       end
     end
    end

    # verify if w/i board & does not include own chess piece
    valid_positions = potential_positions.select { |position| on_board(position) && !pieces.include?($board[position[0]][position[1]]) }
  end

  def pawn_moves(from_square=[0,0], movepiece="", pieces=[])

    wp_init_positions = [[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]]
    wp_passant_positions = [[0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4]]
    wp_capture_position1 = from_square[0] == 7 ? $board[from_square[0]-1][from_square[1]+1] : $board[from_square[0]+1][from_square[1]+1] # to restrict files 7
    wp_capture_position2 = from_square[0] == 0 ? $board[from_square[0]+1][from_square[1]+1] : $board[from_square[0]-1][from_square[1]+1] # to restrict files 0
    wp_position_infront = $board[from_square[0]+0][from_square[1]+1]

    bp_init_positions = [[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6]]
    bp_passant_positions = [[0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3]]
    bp_capture_position1 = from_square[0] == 7 ? $board[from_square[0]-1][from_square[1]-1] : $board[from_square[0]+1][from_square[1]-1] # to restrict files 7
    bp_capture_position2 = from_square[0] == 0 ? $board[from_square[0]+1][from_square[1]-1] : $board[from_square[0]-1][from_square[1]-1] # to restrict files 0
    bp_position_infront = $board[from_square[0]+0][from_square[1]-1]
    left_square = $board[from_square[0]-1][from_square[1]] if from_square[0].between?(1,7)
    right_square = $board[from_square[0]+1][from_square[1]] if from_square[0].between?(0,6)

    moves = []
    if movepiece == "p"
      if wp_position_infront != " "         # blocked

        if wp_passant_positions.include?(from_square) # from en passant position
          if from_square[0].between?(1,6)
            if left_square && right_square == "P" || left_square == "P" && wp_capture_position1 != " " || right_square == "P" && wp_capture_position2 != " "
              moves = [[-1, +1], [+1, +1]]
            elsif left_square == "P" || wp_capture_position2 != " "
              moves = [[-1, +1]]
            elsif right_square == "P" || wp_capture_position1 != " "
              moves = [[+1, +1]]
            end
          elsif from_square[0] == 0 && right_square == "P" || wp_capture_position1 != " "
            moves = [[+1, +1]]
          elsif from_square[0] == 7 && left_square == "P" || wp_capture_position2 != " "
            moves = [[-1, +1]]
          end


        elsif !wp_passant_positions.include?(from_square) # not from en passant position
          if wp_capture_position1 != " " && wp_capture_position2 != " "      # capture positions are occupied
            moves = [[+1, +1], [-1, +1]]
          elsif wp_capture_position1 != " " && wp_capture_position2 == " "   # opponent in one capture position
            moves = [[+1, +1]]
          elsif wp_capture_position2 != " " && wp_capture_position1 == " "   # opponent in other capture position
            moves = [[-1, +1]]
          end
        end

      elsif wp_position_infront == " "      # not blocked

        if wp_passant_positions.include?(from_square) # from en passant position
          if from_square[0].between?(1,6)
            if left_square && right_square == "P" || left_square == "P" && wp_capture_position1 != " " || right_square == "P" && wp_capture_position2 != " " # capture positions are occupied
              moves = [[-1, +1], [+1, +1], [0, +1]]
            elsif left_square == "P" || wp_capture_position2 != " "  # opponent in other capture position
              moves = [[-1, +1], [0, +1]]
            elsif right_square == "P" || wp_capture_position1 != " "  # opponent in one capture position
              moves = [[+1, +1], [0, +1]]
            elsif wp_capture_position1 == " " && wp_capture_position2 == " "      # nothing in capture positions
              moves = [[+0, +1]]
            end
          elsif from_square[0] == 0 && right_square == "P" || wp_capture_position1 != " "
            moves = [[+1, +1], [0, +1]]
          elsif from_square[0] == 7 && left_square == "P" || wp_capture_position2 != " "
            moves = [[-1, +1], [0, +1]]
          else
            moves = [[0, +1]]
          end

        elsif wp_init_positions.include?(from_square) # from initial position
          if wp_capture_position1 == " " && wp_capture_position2 == " "      # nothing in capture positions
            moves = [[+0, +1], [+0, +2]]
          elsif wp_capture_position1 != " " && wp_capture_position2 != " "   # capture positions are occupied
            moves = [[+0, +1], [+0, +2], [+1, +1], [-1, +1]]
          elsif wp_capture_position1 != " " && wp_capture_position2 == " "   # opponent in one capture position
            moves = [[+0, +1], [+0, +2], [+1, +1]]
          elsif wp_capture_position2 != " " && wp_capture_position1 == " "   # opponent in other capture position
            moves = [[+0, +1], [+0, +2], [-1, +1]]
          end

        elsif !wp_init_positions.include?(from_square) # not from initial position
          if wp_capture_position1 == " " && wp_capture_position2 == " "      # nothing in capture positions
            moves = [[+0, +1]]
          elsif wp_capture_position1 != " " && wp_capture_position2 != " "   # capture positions are occupied
            moves = [[+0, +1], [+1, +1], [-1, +1]]
          elsif wp_capture_position1 != " " && wp_capture_position2 == " "   # opponent in one capture position
            moves = [[+0, +1], [+1, +1]]
          elsif wp_capture_position2 != " " && wp_capture_position1 == " "   # opponent in other capture position
            moves = [[+0, +1], [-1, +1]]
          end
        end
      end

    elsif movepiece == "P"
      if bp_position_infront != " "         # blocked

        if bp_passant_positions.include?(from_square) # from en passant position
          if from_square[0].between?(1,6)
            if left_square && right_square == "p" || left_square == "p" && bp_capture_position1 != " " || right_square == "p" && bp_capture_position2 != " "
              moves = [[-1, -1], [+1, -1]]
            elsif left_square == "p" || bp_capture_position2 != " "
              moves = [[-1, -1]]
            elsif right_square == "p" || bp_capture_position1 != " "
              moves = [[+1, -1]]
            end
          elsif from_square[0] == 0 && right_square == "p" || bp_capture_position1 != " "
            moves = [[+1, -1]]
          elsif from_square[0] == 7 && left_square == "p" || bp_capture_position2 != " "
            moves = [[-1, -1]]
          end

        elsif !bp_passant_positions.include?(from_square) # not from en passant position
          if bp_capture_position1 != " " && bp_capture_position2 != " "      # capture positions are occupied
            moves = [[+1, -1], [-1, -1]]
          elsif bp_capture_position1 != " " && bp_capture_position2 == " "   # opponent in one capture position
            moves = [[+1, -1]]
          elsif bp_capture_position2 != " " && bp_capture_position1 == " "   # opponent in other capture position
            moves = [[-1, -1]]
          end
        end

      elsif bp_position_infront == " "      # not blocked

        if bp_passant_positions.include?(from_square) # from en passant position
          if from_square[0].between?(1,6)
            if left_square && right_square == "p" || left_square == "p" && bp_capture_position1 != " " || right_square == "p" && bp_capture_position2 != " " # capture positions are occupied
              moves = [[-1, -1], [+1, -1], [0, -1]]
            elsif left_square == "p" || bp_capture_position2 != " " # opponent in other capture position
              moves = [[-1, -1], [0, -1]]
            elsif right_square == "p" || bp_capture_position1 != " "  # opponent in one capture position
              moves = [[+1, -1], [0, -1]]
            elsif bp_capture_position1 == " " && bp_capture_position2 == " "      # nothing in capture positions
              moves = [[+0, -1]]
            end
          elsif from_square[0] == 0 && right_square == "p" || bp_capture_position1 != " "
            moves = [[+1, -1], [0, -1]]
          elsif from_square[0] == 7 && left_square == "p" || bp_capture_position2 != " "
            moves = [[-1, -1], [0, -1]]
          else
            moves = [[0, -1]]
          end

        elsif bp_init_positions.include?(from_square) # from initial position
          if bp_capture_position1 == " " && bp_capture_position2 == " "      # nothing in capture positions
            moves = [[+0, -1], [+0, -2]]
          elsif bp_capture_position1 != " " && bp_capture_position2 != " "   # capture positions are occupied
            moves = [[+0, -1], [+0, -2], [+1, -1], [-1, -1]]
          elsif bp_capture_position1 != " " && bp_capture_position2 == " "   # opponent in one capture position
            moves = [[+0, -1], [+0, -2], [+1, -1]]
          elsif bp_capture_position2 != " " && bp_capture_position1 == " "   # opponent in other capture position
            moves = [[+0, -1], [+0, -2], [-1, -1]]
          end

        elsif !bp_init_positions.include?(from_square) # not from initial position
          if bp_capture_position1 == " " && bp_capture_position2 == " "      # nothing in capture positions
            moves = [[+0, -1]]
          elsif bp_capture_position1 != " " && bp_capture_position2 != " "   # capture positions are occupied
            moves = [[+0, -1], [+1, -1], [-1, -1]]
          elsif bp_capture_position1 != " " && bp_capture_position2 == " "   # opponent in one capture position
            moves = [[+0, -1], [+1, -1]]
          elsif bp_capture_position2 != " " && bp_capture_position1 == " "   # opponent in other capture position
            moves = [[+0, -1], [-1, -1]]
          end
        end
      end
    end

    valid_positions = []

    moves.collect do |move|
     potential_position = [from_square[0] + move[0], from_square[1] + move[1]]
     valid_positions << potential_position
    end
    valid_positions
  end

  def on_board(from_square=[0,0])
    from_square[0].between?(0,7) && from_square[1].between?(0,7) ? true : false
  end

end
