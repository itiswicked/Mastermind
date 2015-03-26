Mastermind
==========
Recreating the game Mastermind in Ruby

Based on Parker Mastermind cir. 1993

Please see the Wikipedia entry on [Mastermind](http://en.wikipedia.org/wiki/Mastermind_(board_game)) for variations.

#Rules

The computer selects four colors out of 8 available and places them in a specific order.

The Colors are:

  * Red 'Rd'
  * Blue 'Bl'
  * Green 'Gr'
  * Yellow 'Yw'
  * Brown 'Br'
  * Black 'Bk'
  * White 'Wh'
  * Orange 'Or'

It is your task to guess those colors within 10 turns. At the beginning of each turn, select the colors you would like to guess by typing them into the command prompt using the shorthand above, seperated by spaces.

Example:

$ Br Rd Bk Wh

These guesses will show up in the Decode Table. Remember: the order of your guess counts! No duplicate colors are allowed in this version of the game.

At the beginning of each turn you will recieve feedback on your previous guess, 
displayed in the Hint Table.

Hint Table:

  * White ('Wh') hint cells filled in by the program indicate that you have a correct color, but not in the right position
  * Bk ('Bk') hint cells filled in by the program indicate that you have a correct color in the correct position

Happy hunting!