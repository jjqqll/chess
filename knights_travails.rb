# Build a function 'knight_moves' that shows the simplest possible way
# to get from one square to another by outputting all squares the
# knight will stop on along the way.

class GameBoard
  # creates a game board and a knight. the squares on the game GameBoard
  # can be represented as positions/nodes, further represented as parent, children
  attr_accessor :position, :parent

  def initialize(position=nil, parent=nil)
    @position = position
    @parent = parent
  end

  def possible_moves(position)
    # the knight 8 possible moves from a position, provided that the move does not go off the GameBoard
    moves = [[+1, +2], [+2, +1], [+2, -1], [+1, -2], [-1, -2], [-2, -1], [-2, +1], [-1, +2]]

    # valid_positions are positions after making valid 'moves' within the GameBoard
    valid_positions = []
    potential_position = []
    moves.collect do |move|
      potential_position = [position[0] + move[0], position[1] + move[1]]
      valid_positions << potential_position if on_board(potential_position)
      end
    valid_positions
  end

  def on_board(position) # checks if position is within the GameBoard
    position[0].between?(0,7) && position[1].between?(0,7) ? true : false
  end

  # breadth_first_search method
  def knight_moves(start, finish)
    knight = GameBoard.new(start)
    queue = [knight] # adds root node at start position
    until queue.empty?
      current = queue.shift
      # start show_path method if current position is equal to the 'finish' position
      if current.position == finish
        show_path(current)
        break
      else # otherwise, create generate possible_moves(child nodes) from the current position
        moves = possible_moves(current.position) # creates child nodes(possible_moves)
        # push all possible_moves into queue to be checked against 'finish' position,
        # make current position to be parent so that the path can be traced back through parent
        # when show_path method is called
        moves.each {|move| queue << GameBoard.new(move, current)} # add to queue. current becomes parent node
      end
    end
  end

  # show_path is called when 'finish' position is reached in the knight_moves method(when current position is equal to end position)
  # then trace back through parents to get path
  def show_path(location)
    path = []
    until location.nil?
      path << location.position
      location = location.parent
    end
    puts "You made it in #{path.size-1} moves!  Here's your path:"

    path.reverse!
    path.each {|position| p position}
  end

end

test = GameBoard.new
test.possible_moves([6,6])
test.knight_moves([3,3],[3,2])
