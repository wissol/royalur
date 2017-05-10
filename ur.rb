class Square
  
  @@states = [:empty, :one, :two] 
  @@DISC = "\u2B24".encode('utf-8')
  @@rosette = "\u273c".encode('utf-8')
  @@square = "\u2395".encode('utf-8')
  
  def initialize
    @state = :empty
  end
  
  def set_rosette
    @is_rosette = true
  end
  
  def show 
    if @is_rosette
      @@rosette
    else
      @@square
    end
    
  end
  
  def set(new_state)
    if @state == :empty
      @state = new_state
      :ok
    elsif @is_rosette
      :occupied_rosette
    else
      # capture
    end
  end
  

end

class Player
  
  def initialize(player_id)
    @id = player_id
    @tokens_out = 7
    @tokens_in = 0
    @score = 0
  end
  
  def token_finish
    @tokens_in -= 1 
    @score += 1
  end
  
  def token_captured
    @tokens_in -= 1
    @tokens_out += 1
  end
  
  def token_in
    @tokens_in += 1
    @tokens_out -= 1
  end
  
  def won?
    if @score > 6
      puts("You won!")
      true
    else
      false
    end
  end
  
end

class Game
  @@lane_one = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
  @@lane_two = [14,15,16,17,4,5,6,7,8,9,10,11,18,19]
  @@rosettes = [3,7,13,17,19]

  
  def initialize
    @board = Array.new(20) { Square.new }
    @@rosettes.each {|x| @board[x].set_rosette }
    @players =  [ Player.new(:one), Player.new(:two) ]
  end
  
  def show
    @top_row =  [17,16,15,14,nil,nil,19,18]
    @mid_row =  [4 ,5 ,6 ,7 ,8  ,9  ,10,11]
    @last_row = [3,2,1,0,nil,nil,13,12]
    @string = ""
    @top_row.each { 
      |x|
      if x == nil
        @string += " "
      else
        @string += @board[x].show
      end
    }
    puts @string
    @string = ""
    @mid_row.each { 
      |x|
      if x == nil
        @string += " "
      else
        @string += @board[x].show
      end
    }
    puts @string
    @string = ""
    @last_row.each { 
      |x|
      if x == nil
        @string += " "
      else
        @string += @board[x].show
      end
    }
    puts @string
    
  end
    
  
      
end

game = Game.new

game.show
