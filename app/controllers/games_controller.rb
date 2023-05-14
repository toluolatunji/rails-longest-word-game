require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = (("A".."Z").to_a + ("A".."Z").to_a).sample(10)
  end

  def score
    word = params[:word].upcase
    letters = params[:letters]
    in_grid = word_has_letters_in_grid(word, letters)
    if !in_grid
      @response = { ingrid: false, input_word: word, letters: letters.split(' ').join(',') }
    else
      english_word = an_english_word(word)
      if english_word
        @response = { ingrid: true, english_word: true, input_word: word }
      else
        @response = { ingrid: true, english_word: false, input_word: word }
      end
    end
  end

  private

  def word_has_letters_in_grid(word, letters)
    letters_in_word = word.split('')
    letters_in_word.each do |letter|
      return false unless letters.include?(letter)
    end
    true
  end

  def an_english_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response_serialized = URI.open(url).read
    response = JSON.parse(response_serialized)
    response["found"]
  end
end
