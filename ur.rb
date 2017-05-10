require 'colorize'
DISC = "\u2B24".encode('utf-8')
COLORS = { :empty => :yellow, :one => :red, :two => :blue}
KEYS = ["q","w","e","r","t",]

class Square

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
      @answer = @@rosette
    else
      @answer = @@square
    end
      @answer.colorize(COLORS[@state])
  end

  def set(new_state)
    if @state == :empty
      @state = new_state
      :ok
    elsif @is_rosette
      :occupied_rosette
    else
      :capture
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

  def show_tokens_out
    ("o" * @tokens_out).colorize(COLORS[@id])
  end

  def roll_dice
    @one_dice = [0,1]
    @luck = 0
    4.times {
      @luck += @one_dice.sample
    }
    @luck
  end
end

class Game
  @@lane_one = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
  @@lane_two = [14,15,16,17,4,5,6,7,8,9,10,11,18,19]
  @@rosettes = [3,7,13,17,19]
  @@rows =  [
    [17,16,15,14,nil,nil,19,18],
    [4 ,5 ,6 ,7 ,8  ,9  ,10,11],
    [3,2,1,0,nil,nil,13,12]
  ]
  @@keys = {
    "q"=>17, "w"=>16, "e"=>15, "r"=>14, "t"=>19, "y"=>18,
    "a"=>4, "s"=>5, "d"=>6, "f"=>7, "g"=>8, "h"=>8, "j"=>9, "k"=>10, "l"=>11,
    "z"=>3, "x"=>2, "c"=>1, "v"=>0, "b"=>13, "n"=>12,
    "p"=>-1
            }

  def initialize
    @board = Array.new(20) { Square.new }
    @@rosettes.each {|x| @board[x].set_rosette }
    @players =  [ Player.new(:one), Player.new(:two) ]
    @active = @players[0]
  end

  def print_row(a_row)
    @string ="\t"
    a_row.each {
      |x|
      if x == nil
        @string += " "
      else
        @string += @board[x].show
      end
    }
    puts @string
  end

  def show
    puts
    @@rows.each { |row| print_row(row) }
    puts
    @players.each{
      |player|
      puts "\t #{player.show_tokens_out}"
    }
    puts
  end

  def turn
    show


end

game = Game.new

game.show
