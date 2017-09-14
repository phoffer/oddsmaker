module Oddsmaker
  # Market is a container of multiple odds. This is useful to represent the full data of sports betting.
  # A generic moneyline of +300/-400 can be represented by a market, containing both of the individual odds.
  # This also allows for calculating the total probability, which will be over 100% if set by a sportsbook.
  # Additional functions include the ability to determine the odds without vig (the book's profit),
  # and the ability to calculate odds for a given overround (the total probability above 100%).
  class Market
    attr_reader :odds, :vigged, :name

    def initialize(*odds, name: nil)
      @name = name
      @odds = odds.flatten
    end

    # Retrieve an odd by identifier.
    # 
    # @param id [String, Integer] Odd identifier. Defaults to provided value.
    # @return [Odd]
    def odd(id)
      odds_hash[id]
    end

    # Total probability for a set of odds.
    # This will be over 1 if set by a sportsbook.
    # 
    # @return [Float] Total probability, with 1.0 representing 100%
    def total_probability
      @total_probability ||= @odds.inject(0) { |total, odd| total + odd.implied_probability.value } # Change to #sum when 2.3 support can be dropped
    end

    # Calculate equivalent market without any overround (vig).
    # 
    # @return [Market] New market with total probability == 1.0
    def without_vig
      self.class.new(without_vig_odds)
    end

    # Calculate the odds without any overround (vig).
    # 
    # @return [<Odd>] Array of odds with the vig removed
    def without_vig_odds
      @without_vig_odds = if total_probability != 1.0
        @odds.map { |odd| odd.without_vig(total_probability) }
      else
        @odds
      end
    end

    # Total vig (maximum vig under balanced book scenario)
    # 
    # @return [Float]
    def vig
      1 - total_probability**-1
    end

    # Create market with an added overround amount
    # 
    # @param v [Integer] Overround percent
    # @return [Market] New market with overrounded odds
    def overround!(v = 5)
      @vigged = self.class.new(overround_odds!(v))
    end

    # Calculate the odds with given overround
    # 
    # @param v [Integer] Overround percent
    # @return [Array<Odd>] Overrounded odds
    def overround_odds!(v = 5)
      without_vig_odds.map { |odd| odd.overround!(v) }
    end

    # Compare equality to another market
    # 
    # @param other [Market]
    # @return [Boolean]
    def ==(other)
      odds.sort == other.odds.sort
    end

    # Hash representation of a market.
    # @return [Hash]
    def to_h
      full_odds = if self.total_probability != 1
        no_vig = self.without_vig_odds
        odds.map.with_index { |odd, index| odd.to_h.merge(actual: no_vig[index].implied_probability.value, without_vig: no_vig[index].value) }
      else
        odds.map(&:to_h)
      end
      {
        name:               self.name,
        total_probability:  self.total_probability,
        vig:                self.vig,
        odds:               full_odds,
      }
    end

    # JSON representation of a market.
    # @return [String]
    def to_json
      to_h.to_json
    end

    private

    # Hash of odds by name or identifier
    #
    # @return [Hash{String=>Odd}]
    def odds_hash
      @odds_hash ||= @odds.map { |o| [o.id, o] }.to_h.tap do |hash|
        raise 'Must use unique odds identifiers' if hash.size != @odds.size # TODO create custom error classes
      end
    end

  end
end
