class Player
  attr_accessor :input, :turn, :colors

  def initialize
    @input = []
    @turn = 0
    @colors = ["Rd","Bl","Gr","Yw","Br","Or","Bk","Wh"]
  end

  def valid_input?
   input.length == 4 && input.all? { |color| colors.include? color }
  end

  def win?(answer)
    input == answer
  end

  def lose?
    turn > 8
  end

  def end_turn
    @turn += 1
  end

end

class Display

  def tables(hint_table,decode_table)
    puts titles
    decode_table.each_with_index do |decode_row, turn|
      puts "#{turn}           #{hint_table[turn].join(" | ")}        #{decode_row.join(" | ")}"
    end
  end

  def titles
    "Turn           Hint Table              Decode Table"
  end

end

class Hint
  attr_accessor :table, :current_hint

  def initialize
    @table = [["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"]]
    @current_hint = []
  end


  def create(input,answer,turn)
    input.each_with_index do |input_color,input_index|
      answer.each_with_index do |answer_color,answer_index|
        if input_color == answer_color && input_index == answer_index
          current_hint << "Bk"
        elsif input_color == answer_color
          current_hint << "Wh"
        end
      end
    end
    append
    current_hint.sort
    update(turn)
    delete
  end

  private

  def update(turn)
    table[turn] = current_hint
  end

  def delete
    @current_hint = []
  end

  def append
    while current_hint.length < 4
      current_hint << "--"
    end
  end

end

class Decode
  attr_accessor  :table

  def initialize
    @table = [["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"],
              ["--","--","--","--"]]
  end

  # turn is index(row) of decode_table to be replaced,
  # update is 4 element array to replace the one there.
  def update(colors,turn)
    table[turn] = colors
  end

end

class Game
  attr_accessor :player, :decode, :hint, :display, :colors, :answer

  def initialize
    @player  = Player.new
    @decode  = Decode.new
    @hint    = Hint.new
    @display = Display.new
    @colors  = ["Rd","Bl","Gr","Yw","Br","Or","Bk","Wh"]
    @answer  = ["Gr","Yw","Br","Or"]
  end

  ##########################################################################
  ### Methods commented out are for later expansion to play as codemaker ###
  ##########################################################################

  #def start
  #  loop do
  #    puts "Please choose Self or Comp to determine your role:"
  #    user_role = gets.chomp.capitalize
  #    if user_role == "Self" || "Comp"
  #      select_user_path
  #      break
  #    else
  #       puts "Invalid input, try again."
  #    end
  #  end
  #end

  #def select_user_path
  #  case user_role
  #  when "Self"
  #    play_as_codebreaker
  #  when "Comp"
  #    play_as_codemaker
  #  end
  #end

  def play_as_codebreaker
    # answer = colors.sample(4)
    loop do
      display.tables(hint.table,decode.table)
      puts "Please enter your guess #{colors.join(' | ')}:"
      player.input = gets.split.map(&:capitalize)
      if player.valid_input?
        if player.win?(answer)
          puts "You won! #{display_answer}"
          exit
        elsif player.lose?
          puts "You lost! #{display_answer}"
          exit
        else
          complete_turn
        end
      else
        puts "Not a valid input!"
      end
    end
  end

  #def play_as_codemaker
  #  puts "Please select code colors:"
  #  answer = gets.split.map(&:capitalize)
  #  loop do
  #    player.input = colors.sample(4)
  #    display.tables(hint.table,decode.table)
  #    if player.win?(answer)
  #      puts "Computer Won!"
  #      exit
  #    elsif player.lose?
  #      puts "Computer Lost!"
  #      exit
  #    else
  #      complete_turn
  #    end
  #  end
  #end

  def display_answer
    "Answer: #{answer.join(' | ')}"
  end

  def complete_turn
    hint.create(player.input,answer,player.turn)
    decode.update(player.input,player.turn)
    player.end_turn
  end

end

puts "\nWelcome to Mastermind! Refer to the readme for the rules!"
# puts "\n\nYou can choose to solve the code yourself(Self), or set the code and watch the computer attempt to solve it(Comp)."

game = Game.new
game.play_as_codebreaker
