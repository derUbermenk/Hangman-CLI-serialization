require 'pry-byebug'
class Player
  include Display
  attr_accessor :life

  def initialize
    @life = 0
  end

  def guess(possible_choices)
    input = nil
    until valid_input(input, possible_choices)
      display_player_input_prompt
      input = cleaned_input(gets.chomp)
    end

    input
  end

  def valid_input(input, choices)
    if input.nil?
      false
    else
      value = input.values
      key = input.keys[0]

      return key if %w[s q].include? key

      choices.include?(key[0].to_i) && value[0].length == 1
    end
  end

  def cleaned_input(input)
    if input.downcase == 's' || input.downcase == 'q'
      [[input.downcase, nil]].to_h
    else
      input = [input.split(' ')].to_h
      [[input.keys[0].to_i, input.values[0]]].to_h
    end
  end
end
