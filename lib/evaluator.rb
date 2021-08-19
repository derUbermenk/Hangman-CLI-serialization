require 'pry-byebug'

class Evaluator
  include Display
  def make_word
    word = File.readlines('5desk.txt').sample.chomp
    char_position = 0
    word.split('').each_with_object({}) do |char, hash|
      hash[char_position] = char
      char_position += 1
    end
  end

  # returns true or false
  # @param player_input [Hash] where k is position, v is value
  # @param word [Hash] where k is position and v is value
  # @return [TrueClass, FalseClass]
  def evaluate(player_input, word)
    position = player_input.keys[0]
    guess_value = player_input.values[0]
    return true if guess_value == word[position]

    false
  end
end
