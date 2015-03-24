class Player
  attr_accessor :user_input, :turn, :hint, :code, :board

  def initialize
    @user_input = Array.new
    @turn = 0
    @hint = []
    @board = Board.new
    @code = CodeSelector.new
  end

# Do all user_input elements equal an element in code.colors array?
  def valid_input?
    if user_input.length == 4
      user_input.all? do |input_color|
        code.colors.any? do |code_color|
          code_color == input_color
        end
      end
    end
  end

  # For every answer element and its index that equals a user_input element
  # and its input index, push "Rd" to hint array. 
  # For every answer element that equals a user input element, but not
  # neccesarily its index, push "Wh" to the hint array.
  def create_hint
    user_input.each_with_index do |color, index|
      code.answer.each_with_index do |code_color, code_index|
        if color == code_color && index == code_index
          hint << "Rd"
        elsif color == code_color
          hint << "Wh"
        end
      end
    end
  end

  def fill_in_hint
    while hint.length < 4
      hint << "--"
    end
  end

  def win?
    user_input == code.answer
  end

  def lose?
    turn > 9
  end

  def end_turn
    @turn = @turn + 1
  end

end


class Board
  attr_accessor :decode_table, :hint_table

  def initialize
    # The playing 'surface' in which the user makes guesses. One row per turn.
    @decode_table = [["--","--","--","--"],
                     ["--","--","--","--"],
                     ["--","--","--","--"],
                     ["--","--","--","--"],
                     ["--","--","--","--"],
                     ["--","--","--","--"],
                     ["--","--","--","--"],
                     ["--","--","--","--"],
                     ["--","--","--","--"],
                     ["--","--","--","--"]]
    # A place for the program to give feedback on the user guess.           
    @hint_table = [["--","--","--","--"],
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

  def show_titles
    "Turn       Hint Table            Decode Table".center(20)
  end
# upon each iteration, returns decode and hint row inline.
  def show
    decode_table.each_with_index do |decode_row, index|
      puts "#{index}      " + "#{hint_table[index].join(" | ")}   " "   #{decode_row.join(" | ")}"
    end
  end
# turn is index(row) of decode_table to be replaced,
# update is 4 element array to replace the one there.
  def update_decode_table(turn,update)  
    decode_table[turn] = update
  end
  
  def update_hint_table(turn,update)
    hint_table[turn] = update
  end

end

class CodeSelector
  attr_accessor :answer, :colors, :color_choices

  def initialize
    @answer = []
    @colors = ["Rd","Bl","Gr","Yw",
               "Br","Or","Bk","Wh"]
    @color_choices = ["Rd","Bl","Gr","Yw",
                      "Br","Or","Bk","Wh"]
  end

  def select_answer
    4.times do
      answer << color_choices.random_select
      delete_color
    end
  end


  def delete_color
    color_choices.delete(answer.last)
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

p.code.select_answer

loop do
  puts p.board.show_titles
  p.board.show
  puts "Please enter your guess:"
  p.user_input = gets.chomp.split.map(&:capitalize)
  if p.valid_input?
    if p.win?
      puts "You won!"
    elsif p.lose?
      puts "You lost!"
    else
      p.create_hint
      p.fill_in_hint
      p.board.update_hint_table(p.turn,p.hint)
      p.board.update_decode_table(p.turn,p.user_input)
      p.end_turn
    end
  else
    puts "Not a valid input!"
  end
  p.hint = []
end
