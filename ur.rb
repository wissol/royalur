require 'colorize'
COLORS = { :empty => :yellow, :one => :red, :two => :blue}

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
      @is_rosette ? :rosette : :ok
    elsif @is_rosette
      :occupied_rosette
    elsif @state == new_state
      :same_player
    else
      @state = new_state
      :capture
    end
  end

  def reset
    @state = :empty
  end

  def state
    @state
  end
end

class Player

  def initialize(player_id)
    @id = player_id
    @tokens_out = 7
    @score = 0
  end

  def token_finish
    @score += 1
  end

  def token_captured
    @tokens_out += 1
  end

  def token_in
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

  def who
    @id == :one ? "Red" : "Blue"
  end

  def id
    @id
  end

  def tokens_out?
    @tokens_out > 0 ? true : false
  end

  def tokens_out_mod(inc)
    @tokens_out += inc
  end
end

class Game
  @@messages = {
    :help =>
    "Press a key to choose the square you want to move from.\n" +
    "w selects the first square in the first row.\n" +
    "The other squares go in this fashion:\n\n" +
    "\tqwerty\n" +
    "\tasdefghjk\n" +
    "\tzxcvbn\n\n" +
    "p to get a new piece in the board.",
    :nokey =>
    "Sorry, wrong key"
  }
  @@lanes = {
    :one => [0,1,2,3,4,5,6,7,8,9,10,11,12,13],
    :two => [14,15,16,17,4,5,6,7,8,9,10,11,18,19]
  }
  @@rosettes = [3,7,13,17,19]
  @@rows =  [
    [17,16,15,14,nil,nil,19,18],
    [4 ,5 ,6 ,7 ,8  ,9  ,10,11],
    [3,2,1,0,nil,nil,13,12]
  ]
  @@keys = {
    "q"=>17, "w"=>16, "e"=>15, "r"=>14, "t"=>19, "y"=>18,
    "a"=>4, "s"=>5, "d"=>6, "f"=>7, "g"=>8, "h"=>9, "j"=>10, "k"=>11,
    "z"=>3, "x"=>2, "c"=>1, "v"=>0, "b"=>13, "n"=>12,
    "p"=>-1
            }

  def initialize
    @board = Array.new(20) { Square.new }
    @@rosettes.each {|x| @board[x].set_rosette }
    @players =  [ Player.new(:one), Player.new(:two) ]
    puts @players[0].id
    @player = @players[0]
    @dice = 0
  end

  def go_in_lane(from, steps, id)
    lane = @@lanes[id]
    from = lane.find_index(from) unless from == -1
    target = from + steps
    puts("target, #{target} = #{from} + #{steps}")
    if target < 14
      @board[lane[target]]
    elsif target == 14
      :goal
    else
      :went_over
    end
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

  def switch_player
    @player.id == :one ? @players[1] : @players[0]
  end

  def stone_finish(key)
    @board[key].reset
    @player.token_finish
  end

  def choose_move
    puts "Choose your move, ? for help"
    move = gets[0]
    if move == "?"
      puts @@messages[:help]
    elsif @@keys.include?(move)
      puts "include move #{move}"
      key = @@keys[move]
      puts "#{@board[key].state} == #{@player.id}"
      if key == -1
        if @player.tokens_out?
          square = go_in_lane(key,@dice,@player.id)
          square.set(@player.id)
          @player.tokens_out_mod(-1)
        else
          puts("sorry, no tokens out")
          choose_move
        end
      elsif @board[key].state == @player.id
        square = go_in_lane(key,@dice,@player.id)
        if square == :goal
          stone_finish(key)
        elsif square == :went_over
          puts "Sorry, you need to roll the exact number to exit the board"
          choose_move
        else
          reason = square.set(@player.id)
          if reason == :ok
            @board[key].reset
          elsif reason == :rosette
            @board[key].reset
            @player = switch_player # player will be switched again as we have another turn
          elsif reason == :same_player
            puts "You already have a stone there"
          elsif reason == :occupied_rosette
            puts "You can't move into an occupied rosette"
          else
            @board[key].reset
            @player = switch_player
            @player.token_captured
            @player = switch_player
          end
        end
      else
        puts "That is not a token of yours"
        choose_move
      end
    else
      puts @@messages[:nokey]
      choose_move
    end
  end

  def dice
    puts "Player #{@player.who} hit enter to roll your dice"
    gets
    @dice = 0
    4.times { @dice += [0,1].sample }
    puts "You rolled #{@dice}"
  end



  def turn
    until @player.won?
      show
      dice
      if @dice == 0
        puts "Sorry, lost your turn"
      else
        choose_move
      end
      @player = switch_player
    end
  end


end

game = Game.new

game.turn
