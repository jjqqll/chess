require_relative 'chessplayer.rb'
require_relative 'chesspieces.rb'

class GameBoard
  attr_accessor :board, :player, :player1, :player2, :move_piece, :set_board, :from_square, :to_square, :turn_number, :options, :wp_promotion_rank, :bp_promotion_rank

  def initialize(name1 = "Player 1", name2 = "Player 2")
    $board = Array.new(8) { Array.new(8, ' ') }
    @player = player
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
    @chesspieces = ChessPieces.new
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
    print "\nWelcome to Chess!\n\nThe player with the white(lower cases) pieces moves first.\n"
  end

  def turns
    while true
      turn
      display
      @turn_number += 1
      if @turn_number == 1
        set_board
      end
      break if draw || lost
      #if check?(opponent_king_position) && get_out_of_check_moves == 0
      #  print "\n'Checkmate'\n"
      if check?(opponent_king_position)
        print "\n'Check'\n\n"
      end
    end
#    puts "It's a draw!" if draw
#    puts "#{player.name}, you lost!" if lost
  end

  def turn
    @player = @turn_number.even? ? @player2 : @player1

    if draw || lost
      puts "It's a draw!" if draw
      puts "Checkmate!\n\n#{player.name}, you lost!" if lost
      return
    end

    @from_square = @player.take_turn_from(@options)

    if in_check?(your_king_position)
      until get_out_of_check_moves.include?(@from_square)
        print "Invalid selection. Try again:\n> "
        @from_square = @player.take_turn_from(@options)
      end
#    elsif put_king_at_risk?(@from_square) # moving other pieces will put own king in check
#      until put_king_at_risk?(@from_square) == false
#        print "Invalid selection. Try again:\n> "
#        @from_square = @player.take_turn_from(@options)
#      end
    elsif move_king_into_check? # move will put own king into check
      until move_king_into_check? == false
        print "Invalid selection. Try again:\n> "
        @from_square = @player.take_turn_from(@options)
      end
    end

    $move_piece = $board[from_square[0]][from_square[1]]
    @to_square = @player.take_turn_to(@options)

    if $move_piece == "k" || $move_piece == "K"
      until available_moves_for_king.include?(@to_square)
        print "Invalid selection. Try again:\n> "
        @to_square = @player.take_turn_to(@options)
      end
    elsif in_check?(your_king_position)
        until get_out_of_check_moves.include?(@to_square)
          print "Invalid selection. Try again:\n> "
          @to_square = @player.take_turn_to(@options)
        end
    end

    castling
    delete_disc(player, from_square[0], from_square[1])
    add_disc(player, to_square[0], to_square[1])
  end

  def delete_disc(player=nil, from_square1, from_square2)
    $board[from_square1][from_square2] = " "
    en_passant_delete
  end

  def add_disc(player=nil, to_square1, to_square2)
    # pawn promotion
    if $move_piece == "p" && @wp_promotion_rank.include?(@to_square)
      print "\n What would you like to promote your pawn to? queen, rook, bishop or knight? "
      input3 = $stdin.gets.chomp

      until player.pieces.include?(input3)
        print "That is an incorrect value! Try again:\n"
        input3 = $stdin.gets.chomp
      end
      $board[to_square[0]][to_square[1]] = input3

    elsif $move_piece == "P" && @bp_promotion_rank.include?(@to_square)
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

  def en_passant_delete
    wp_passant_positions, bp_passant_positions = [], []
    0.upto(7) {|x| wp_passant_positions << [x,4]}
    0.upto(7) {|x| bp_passant_positions << [x,3]}
    enpassant_captures = [[@from_square[0]-1, @from_square[1]], [@from_square[0]+1, @from_square[1]]]

    if $move_piece == "p" && wp_passant_positions.include?(@from_square) && enpassant_captures.include?([@to_square[0], @to_square[1]-1])
      $board[@to_square[0]][@to_square[1]-1] = " "
    elsif $move_piece == "P" && bp_passant_positions.include?(@from_square) && enpassant_captures.include?([@to_square[0], @to_square[1]+1])
      $board[@to_square[0]][@to_square[1]+1] = " "
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

  def opponent_king_position
    opponent_king = player.pieces.include?("k") ? "K" : "k"

    0.upto(7) do |x|
      0.upto(7) do |y|
        return opponent_king_position = [x, y] if $board[x][y] == opponent_king
      end
    end
  end

  def your_king_position
    your_king = player.pieces.include?("k") ? "k" : "K"

    0.upto(7) do |x|
      0.upto(7) do |y|
        return your_king_position = [x, y] if $board[x][y] == your_king
      end
    end
  end

  def opponent_pieces
    player.pieces.include?("k") ? ["R", "N", "B", "Q", "K", "P"] : ["r", "n", "b", "q", "k", "p"]
  end

  def your_pieces
    player.pieces.include?("k") ? ["r", "n", "b", "q", "k", "p"] : ["R", "N", "B", "Q", "K", "P"]
  end

  def your_pieces_positions
    your_pieces_positions = []
    0.upto(7) do |x|
      0.upto(7) do |y|
        your_pieces_positions << [x,y] if player.pieces.include?($board[x][y])
      end
    end
    your_pieces_positions
  end

  def opponent_pieces_positions
    opponent_pieces_positions = []
    0.upto(7) do |x|
      0.upto(7) do |y|
        opponent_pieces_positions << [x,y] if opponent_pieces.include?($board[x][y])
      end
    end
    opponent_pieces_positions
  end

  # check if you put opponent in check
  def check?(coordinate)
    moves = []
    your_pieces_positions.each { |position| moves << available_moves(position, player.pieces) if position != [] }
    moves.flatten(1).include?(coordinate) ? true : false
  end

  # check if this coordinate is in check by opponent
  def in_check?(coordinate)
    moves = []
    opponent_pieces_positions.each { |position| moves << available_moves(position, opponent_pieces) if position != [] }
    moves.flatten(1).include?(coordinate) ? true : false
  end

  # return chess piece's available moves
  def available_moves(coordinate, chess_pieces)
    available_moves = []
    chess_piece = $board[coordinate[0]][coordinate[1]]
    case
      when chess_piece == "r" || chess_piece == "R"
        return available_moves = @chesspieces.rook_moves(coordinate, chess_pieces)
      when chess_piece == "n" || chess_piece == "N"
        return available_moves = @chesspieces.knight_moves(coordinate, chess_pieces)
      when chess_piece == "b" || chess_piece == "B"
        return available_moves = @chesspieces.bishop_moves(coordinate, chess_pieces)
      when chess_piece == "q" || chess_piece == "Q"
        return available_moves = @chesspieces.queen_moves(coordinate, chess_pieces)
      when chess_piece == "k"
        return available_moves =
        if $counter_k == 0
          if coordinate == [4,0] && $board[7][0] == 'r' && $board[5][0] && $board[6][0] == ' '
            @chesspieces.king_moves(coordinate, chess_pieces) << [6,0]
          elsif coordinate == [4,0] && $board[0][0] == 'r' && $board[1][0] && $board[2][0] && $board[3][0] == ' '
            @chesspieces.king_moves(coordinate, chess_pieces) << [2,0]
          else
            @chesspieces.king_moves(coordinate, chess_pieces)
          end
        else
          @chesspieces.king_moves(coordinate, chess_pieces)
        end
      when chess_piece == "K"
        return available_moves =
        if $counter_K == 0
          if coordinate == [4,7] && $board[7][7] == 'R' && $board[5][7] && $board[6][7] == ' '
            @chesspieces.king_moves(coordinate, chess_pieces) << [6,7]
          elsif coordinate == [4,7] && $board[0][7] == 'R' && $board[1][7] && $board[2][7] && $board[3][7] == ' '
            @chesspieces.king_moves(coordinate, chess_pieces) << [2,7]
          else
            @chesspieces.king_moves(coordinate, chess_pieces)
          end
        else
          @chesspieces.king_moves(coordinate, chess_pieces)
        end
      when chess_piece == "p" || chess_piece == "P"
        return available_moves = @chesspieces.pawn_moves(coordinate, chess_piece, chess_pieces)
    end
  end

  def put_king_in_check?(from=@from_square, to=@to_square)
    from_piece = $board[from[0]][from[1]]
    to_piece = $board[to[0]][to[1]]
    $board[to[0]][to[1]] = $board[from[0]][from[1]]
    $board[from[0]][from[1]] = " "
    result = in_check?(your_king_position)
    $board[from[0]][from[1]] = from_piece
    $board[to[0]][to[1]] = to_piece
    result
  end

=begin
  def put_king_at_risk?(from=@from_square, to=@to_square)
    from_piece = $board[from[0]][from[1]]
    $board[from[0]][from[1]] = " "
    if from_piece == "k" || from_piece == "K"
      to_piece = $board[to[0]][to[1]]
      $board[to[0]][to[1]] = $board[from[0]][from[1]]
      result = in_check?(to)
      $board[to[0]][to[1]] = to_piece
    else
      result = in_check?(your_king_position)
    end
    $board[from[0]][from[1]] = from_piece
    result
  end
=end

  def move_king_into_check?
    available_moves(@from_square, your_pieces).each { |move| return false if put_king_in_check?(@from_square, move) == false}
    true
  end

  def available_moves_for_king
    moves = available_moves(@from_square, your_pieces).select { |move| put_king_in_check?(@from_square, move) == false}
    p moves
  end

  def get_out_of_check_moves # any get out of check moves?
    all_available_moves = []

    your_pieces_positions.each do |from|
      available_moves(from, your_pieces).each do |to|
        if put_king_in_check?(from, to) == false
          all_available_moves << [from, to]
        end
      end
    end
    all_available_moves.flatten(1)
  end

  # no moves available, and your king is in check
  def checkmate
    get_out_of_check_moves.length == 0 && in_check?(your_king_position)
  end

  def stalemate
    get_out_of_check_moves.length == 0 && in_check?(your_king_position) == false
  end

  def lost
    checkmate
  end

  def draw
    stalemate
  end

end
