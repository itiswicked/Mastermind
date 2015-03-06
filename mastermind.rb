# Based on Parker Mastermind cir. 1993

class Game

  attr_accessor :answer
  attr_reader :colors

  def initialize
  	@code = []
    @colors = ["Red","Blue","Green","Yellow",
               "Brown","Orange","Black","White"]
  end

  def push_to_code
    4.times do
      code << colors.random_select
    end
  end

  def random_select
    self[rand(self.size)]
  end

  def delete_color(color)
    colors.delete(color)

end

