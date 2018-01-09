require_relative 'chessboard.rb'

class Player
  attr_accessor :name, :disc

  def initialize(name, disc)
    @name = name
    @disc = disc
  end

  def take_turn(options, stdin = $stdin)
    print "\nPlease select the chess piece you want to move by selecting the square it currently occupies(column# first, then row#).\n> "
    input1 = stdin.gets.chomp.to_i

    until options.include?(input1)
      print "That is an incorrect value! Try again:\n> "
      input1 = stdin.gets.chomp.to_i
    end

    print "\nPlease select the square where you want to move your chess piece to(column# first, then row#).\n> "
    input2 = stdin.gets.chomp.to_i

    until options.include?(input2)
      print "That is an incorrect value! Try again:\n> "
      input2 = stdin.gets.chomp.to_i
    end

    input2
  end
end
