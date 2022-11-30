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
  attr_accessor :hint, :array_code, :last_hint
  def initialize
    @board = Board.new
    c = Code.new
    @code = c.generate
    @input = []
    @sure_numbers =[]
  end
  def check #Compara un input con el codigo a descifrar, entrega la pista asociada (0 = existe y posicion correcta, 1 = existe pero en otra posicion, 2 = no existe en el codigo)
    copy = Marshal.load(Marshal.dump(@code))
    @hint = []
    @input.each_with_index do |v,i|
      if copy[i] == v.to_i
        copy[i] = 0
        @input[i] = ""
        @hint.push(0)
      end
    end
    @input.delete("")
    @input.each_with_index do |v,i|
      if copy.include?(v.to_i)
        copy[copy.index(v.to_i)] = 0
        @hint.push(1)
        next
      elsif v != 0
        @hint.push(2)
      end
    end
    @last_hint = Marshal.load(Marshal.dump(@hint.sort))
    return @hint.sort
  end

  def start #Instruccones y posterior desarrollo del juego
    @turn_counter = 0
    @role = nil
    @last_hint = []
    puts "Welcome to Mastermind!\n
    \n
    The goal of the game is to solve a 4-color code (they can repeat), there are 12 attempts to do so.\n
    Hints will be provided to provide information, black dot implies that the color is in the sequence, and in it's correct postion, and a white dot meand you got a color right but not in it's right place.\n
    "
    while @role == nil
      self.select_mode
    end
    while (@turn_counter <= 11) and (@last_hint != [0,0,0,0])
      if @role == "codebreaker"
        puts "Type your guess, use only a 4 combination of valid numbers (1-6)"
        self.request_code
        @board.display(@array_code,self.check) ####Aqui deberia haber un display
      else
        break
      end
    end
    if @role == "codemaker"
      puts "Type the code you want the computer to guess"
      self.request_code
      @code = @array_code
      @turn_counter = 0
      while (@turn_counter <= 11) and (@last_hint != [0,0,0,0])
        self.break
        @last_input = Marshal.load(Marshal.dump(@input))
        @board.display(@input,self.check)
      end
    end
    if @last_hint == [0,0,0,0]
      self.reset
    else 
      puts "You couldn't guess the code :("
      self.reset
    end    
  end

  def break
    if @turn_counter == 0
      @input = ["1","1","1","1"]
      @turn_counter += 1
      return
    else
      if @last_hint.include?(2)
        
      else
        
      end
  end

  def select_mode #Elegir el rol del jugador
    puts "Please choose wether you want to play as the decoder (1) or if you want the Computer to try and solve your code (2)."
    selection = gets.chomp.to_i
    if selection == 1
      @role = "codebreaker"
    elsif selection == 2
      @role = "codemaker"
    else
      puts "Invalid input, please try again."
    end
  end
  
  def request_code 
    model = ["1","2","3","4","5","6"]
    code_input = gets.chomp.to_i
    @array_code = code_input.to_s.split("")
    if (@array_code - model).empty?
      if @array_code.length == 4
        @input = Marshal.load(Marshal.dump(@array_code)) 
        @turn_counter += 1
      else
        puts "Invalid input, please try again."
      end
    else
      puts "Invalid input, please use only valid numbers (1-6)"
    end
  end

  def reset
    puts "Would you like to try again? Yes (1)  No (2)" 
    selection = gets.chomp.to_i
    if selection == 1
      @try_again = false
      self.start  
    elsif selection == 2
      exit
    else
      @try_again = true
      puts "Invalid input, please try again."
    end  
  end  
end

class Board #Todo lo telacionado con el tablero
  def initialize
    @clues = []
  end
  def display(a,b)
    guess = ""
    a.each do |n|
      if n == "1"
        guess += "\e[41m  1  \e[0m "
      elsif n == "2"
        guess += "\e[42m  2  \e[0m "
      elsif n == "3"
        guess += "\e[43m  3  \e[0m "
      elsif n == "4"
        guess += "\e[44m  4  \e[0m "
      elsif n == "5"
        guess += "\e[45m  5  \e[0m "
      elsif n == "6"
        guess += "\e[46m  6  \e[0m "
      end
    end
    clue = ""
    b.each do |g|
      if g == 0
        clue += "x"
      elsif g == 1 
        clue += "o"
      elsif g == 2
        clue += "."
      end
    end
    if b != [0,0,0,0]
      puts guess + "Clues: " + clue
      puts "Not quite correct"
    elsif b == [0,0,0,0]
      puts guess + "Clues: " + clue
      puts "You have guessed the code!"
    end   

  end
end