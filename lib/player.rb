require_relative 'tilebag'
module Scrabble
  class Player

    attr_reader :name, :plays, :total_score #, :tiles
    attr_accessor :tiles

    def initialize(name)
      raise ArgumentError.new "Name must be string" if name.class != String

      @plays = []
      @name = name
      @total_score = 0
      @dictionary = Scrabble::Dictionary.new
      @tiles = []
    end

    def draw_tiles(tile_bag)
      raise ArgumentError.new "arg must be TileBag object" if tile_bag.class != Scrabble::TileBag
      needed_tiles = 7 - @tiles.length
      new_tiles = []
      new_tiles = tile_bag.draw_tiles(needed_tiles)
      @tiles.push(new_tiles).flatten!
    end

    def validate_word(word)
      @dictionary.validate_players_word(word)
    end

    def play(word)
      valid = validate_word(word)
      if won?
        return false
      else
        raise ArgumentError.new "Not a valid word" if !valid

        @plays << word
        word_score = Scrabble::Scoring.score(word)
        @total_score += word_score
        return word_score
      end
    end

    def won?
      return @total_score >= 100 ? true : false
    end

    def highest_scoring_word
      return Scrabble::Scoring.highest_score_from(@plays)
    end

    def highest_word_score
      Scrabble::Scoring.score(highest_scoring_word)
    end
  end
end
