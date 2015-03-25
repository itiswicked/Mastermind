class Player
  attr_accessor :input, :turn, :decode, :answer, :hint, :display, :colors

  def initialize
    @input = []
    @turn = 0
    @decode = Decode.new
    @answer = Answer.new
    @hint = Hint.new
    @display = Display.new
    @colors = ["Rd","Bl","Gr","Yw",
                "Br","Or","Bk","Wh"]  
  end

  # Do all user_input elements equal an element in colors array?
  def valid_input?
    if input.length == 4
      input.all? do |input_color|
        colors.any? do |code_color|
          code_color == input_color
        end
      end
    end
  end

  def win?
    input == answer.answer
  end

  def lose?
    turn > 8
  end

  def end_turn
    @turn += 1
  end

end

class Display < Player
  # A class specifically for handling merging and displaying the two game tables
  def initialize;end

  def show_titles
    "Turn       Hint Table            Decode Table".center(20)
  end

  # REWRITE SO NOT SO MESSY
  def show_tables(hint_table,decode_table)
    decode_table.each_with_index do |decode_row, index|
      puts "#{index}      " + "#{hint_table[index].join(" | ")}   " "   #{decode_row.join(" | ")}"
    end
  end

end

class Answer
  attr_accessor :answer, :colors

  def initialize
    @answer = []
    @colors = ["Rd","Bl","Gr","Yw",
               "Br","Or","Bk","Wh"]   
  end

  def create
    4.times do
      answer << colors.random_select
      delete_color
    end
  end

  private

  def delete_color
    colors.delete(answer.last)
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
    input.each_with_index do |input_color, index|
      answer.each_with_index do |answer_color, answer_index|
        # if color is present and in the right place
        if input_color == answer_color && index == answer_index 
          current_hint << "Bk"
        # if color is simply present
        elsif input_color == answer_color
          current_hint << "Wh"
        end
      end
    end
  end

  # this method fills in current_hint with the appropriate number of "--"
  # after Bk's Wh's have been populated into it.
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

class Array
  def random_select
    self.fetch(rand(self.size) - 1)
  end

end


p = Player.new

puts "\nWelcome to Mastermind!
\nPlease read the rules at http://en.wikipedia.org/wiki/Mastermind_(board_game).
\nThis program is based on the 1993 edition of Parker Mastermind. The variation
\nrules can also be viewed on the wikipedia page. To make a guess, simply type
\nthe colors in seperated by spaces. Read the readme for color abbreviations."

p.answer.create

loop do
  puts p.display.show_titles
  p.display.show_tables(p.hint.table,p.decode.table)
  puts "Please enter your guess:"
  p.input = gets.chomp.split.map(&:capitalize)
  if p.valid_input?
    if p.win?
      puts "You won!  Answer: #{p.answer.answer.join(' | ')}"
      exit
    elsif p.lose?
      puts "You lost! Answer: #{p.answer.answer.join(' | ')}"
      exit
    else
      p.hint.create(p.input,p.answer.answer)
      p.hint.fill_in
      p.hint.update(p.turn)
      p.decode.update(p.input,p.turn)
      p.hint.current_hint = []
      p.end_turn
    end
  else
    puts "Not a valid input!"
  end
end

