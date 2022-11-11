#Mastermind
#Proyecto para progresar en Odin Project

$rng = Random.new()

class Code #Genera un codigo aleatorio con 4 elementos entre 6 colores, pueden repetirse
  attr_accessor :sequence
  def initialize
    @sequence = []
  end
  def generate
    for a in 1..4 do
      @sequence.push($rng.rand(1..6))
    end
    return @sequence
  end
end

class Game  #Permite el correcto funcionamiento del juego
  attr_accessor :hint
  def initialize
    @board = Board.new
    @c = Code.new
    @code = @c.generate
    @input = []
  end
  def check
    copy = @code
    @hint = []
    @input.each_with_index do |v,i|
      if copy[i] == v
        copy[i] = 0
        @input[i] = ""
        @hint.push(0)
      end
    end
    @input.delete("")
    @input.each_with_index do |v,i|
      if copy.include?(v)
        copy[copy.index(v)] = 0
        @hint.push(1)
        next
      elsif v != 0
        @hint.push(2)
      end
    end
    return @hint.sort
  end
end

class Board #Todo lo telacionado con el tablero
  def initialize
    
  end
  def display

  end
end