class Player;end


class Board
  attr_accessor :decode_table, :display_board, :hint_table

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

  def board_titles
    "Turn       Hint Table            Decode Table".center(20)
  end
# upon each iteration, returns boars and hint row inline.
  def show_boards
    decode_table.each_with_index do |decode_row, index|
      puts "#{index}      " + "#{hint_table[index].join(" | ")}   " "   #{decode_row.join(" | ")}"
    end
  end
# turn is index(row) of decode_table to be replaced,
# update is array to replace the one there.
  def update_decode_table(turn, update)  
    decode_table[turn] = update
  end
  
  def update_hint_table(turn,update)
    hint_table[turn] = update
  end

end

class CodeSelector
  attr_accessor :answer, :colors

  def initialize
  	@answer = []
    @colors = ["Rd","Bl","Gr","Yw",
               "Br","Or","Bk","Wh"]
  end

  def select_answer
    4.times do
      answer << colors.random_select
      delete_color
    end
  end


  def delete_color
    colors.delete(answer.last)
  end
end

class Array
  def random_select
    self.fetch(rand(self.size) - 1)
  end
end



