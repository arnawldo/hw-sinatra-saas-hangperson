class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.to_s.empty? or letter == nil or not letter =~ /[A-Za-z]/
      raise ArgumentError
    end
    letter.downcase!
    if @word.include? letter
      return false if @guesses.include? letter
      @guesses += letter
    else
      return false if @wrong_guesses.include? letter
      @wrong_guesses += letter
    end
    true
  end

  def word_with_guesses
    if @guesses.to_s.empty?
      guess_regex = /[a-z]/
    else
      guess_regex = Regexp.new '[^'+@guesses+']'
    end
    @word.gsub(guess_regex, '-')
  end

  def check_win_or_lose
    if word_with_guesses == @word
      :win
    elsif @guesses.length + @wrong_guesses.length > 6
      :lose
    else
      :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
