class Player
  attr_accessor :input, :turn, :decode, :answer, :hint, :display, :colors

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
  def titles
    "Turn       Hint Table            Decode Table".center(20)
  end

  def tables(hint_table,decode_table)
    decode_table.reduce(0) do |turn, decode_row|
      puts "#{turn}      " + "#{hint_table[turn].join(" | ")}   " "   #{decode_row.join(" | ")}"
      turn + 1
    end
  end

end

class Answer
  attr_accessor :answer, :colors

  def initialize
    @colors = ["Rd","Bl","Gr","Yw","Br","Or","Bk","Wh"]
    @answer = colors.sample(4)
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

  def create(input,answer)
    input.reduce(0) do |position, input_color|
      answer.reduce(0) do |answer_position, answer_color|
        # if color is present and in the right place
        if input_color == answer_color && position == answer_position
          current_hint << "Bk"
        # if color is simply present
        elsif input_color == answer_color
          current_hint << "Wh"
        end
        answer_position + 1
      end
      position + 1
    end
  end

  # this method fills in current_hint with the appropriate number of "--"
  # after Bk's and Wh's have been populated into it.
  def fill_in
    while current_hint.length < 4
      current_hint << "--"
    end
  end

  def update(turn)
    table[turn] = current_hint.sort
  end

  def delete
    current_hint = []
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

Game = Struct.new(:player, :decode, :answer, :hint, :display) do

  def run
    loop do
      puts display.titles
      display.tables(hint.table,decode.table)
      puts "Please enter your guess:"
      player.input = gets.split.map(&:capitalize)
      if player.valid_input?
        if player.win?(answer.answer)
          puts "You won!  Answer: #{answer.answer.join(' | ')}"
          exit
        elsif player.lose?
          puts "You lost! Answer: #{answer.answer.join(' | ')}"
          exit
        else
          hint.create(player.input,answer.answer)
          hint.fill_in
          hint.update(player.turn)
          decode.update(player.input,player.turn)
          hint.current_hint = []
          player.end_turn
        end
      else
        puts "Not a valid input!"
      end
    end
  end

end

game = Game.new(Player.new, Decode.new, Answer.new, Hint.new, Display.new)

puts "Welcome to Mastermind! Refer to the readme for the rules!"

game.run
