module Oddsmaker
  module Odd
    # @abstract Base class to implement common functionality to various types of odds.
    class Base
      include Comparable
      attr_reader :id, :value
      alias :name :id # name is more common scenario, but anything works as an identifier

      # Display odds as a string
      # 
      # @return [String]
      def to_s
        @value.to_s
      end

      # Calculates a new odd, removing the vig.
      # 
      # @return [Odd] Returns the same class as the original object
      def without_vig(total_probability)
        @without_vig = implied_probability.without_vig(total_probability).send(type)
      end

      # Calculates a new odd, with the given overround percentage.
      # 
      # @param v [Integer] Overround percentage (as whole number)
      # @return [Odd] Returns the same class as the original object
      def overround!(v)
        implied_probability.overround!(v).send(type)
      end

      # Calculate implied probability.
      # 
      # @return [ImpliedProbability]
      def implied_probability
        @implied_probability ||= ImpliedProbability.new(calculate_probability, id)
      end

      # Multiplier is commonly used for parlay and other calculations.
      # It's just decimal odds, but we define it to match common terminology.
      # 
      # @return [Float]
      def multiplier
        self.decimal.value
      end

      # Check two odds for equality.
      # 
      # @param other [Odd]
      # @return [Boolean]
      def ==(other)
        implied_probability == other.implied_probability
      end

      # Compare two odds against each other.
      # 
      # @param other [Odd]
      # @return [-1,0,1]
      def <=>(other)
        implied_probability <=> other.implied_probability
      end

      # Make a wager with this odd.
      # 
      # @param amount [Integer, Float] Amount wagered. Can be integer or float.
      # @return [Wager]
      def wager(amount)
        Wager.new(amount, self)
      end

      # Calculate profit for an amount wagered.
      # Convenient if a `Wager` object is unnecessary.
      # 
      # @param amount [Integer, Float] Amount wagered. Can be integer or float.
      # @return [Float, Integer, Rational]
      def profit(amount)
        calculate_profit(amount)
      end

      # Represent odd as a hash.
      # This will include all forms of the odd.
      # @return [Hash]
      def to_h
        {
          name:       self.name,
          american:   self.american.value,
          decimal:    self.decimal.value,
          fractional: self.fractional.value,
          implied:    self.implied_probability.value,
        }
      end

      # JSON representation of the odd.
      # @return [String]
      def to_json
        to_h.to_json
      end

    end
  end
end
