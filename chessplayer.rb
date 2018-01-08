class Player
  attr_accessor :name, :disc

  def initialize(name, disc)
    @name = name
    @disc = disc
  end

  def take_turn(options, stdin = $stdin)
    print "\nPlease select your chess piece then a square on the board for your next move., #{@name} #{@disc} ?\n> "
    input = stdin.gets.chomp.to_i

    until options.include?(input)
      print "That is an incorrect value! Try again:\n> "
      input = stdin.gets.chomp.to_i
    end
    input
  end
end
