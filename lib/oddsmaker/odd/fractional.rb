module Oddsmaker
  module Odd
    # Fractional odds express the fraction of a dollar that would be won from a $1 bet.
    class Fractional < Base

      def initialize(value, id = nil)
        @id    = id || value
        @value = value.is_a?(String) ? value.to_r : value.rationalize
      end

      # Returns self. This creates a consistent API for all odds.
      # 
      # @return [self]
      def fractional
        self
      end

      # Convert to American odds, returning a new object.
      # 
      # @return [American]
      def american
        @american ||= implied_probability.american
      end

      # Convert to decimal odds, returning a new object.
      # 
      # @return [Decimal]
      def decimal
        @decimal ||= implied_probability.decimal
      end

      private

      # Allows for implied probability to create a vigged/unvigged odd and convert it back to source format.
      def type
        :fractional
      end

      # Calculate implied probability of an odd.
      # 
      # @return [Float]
      def calculate_probability
        @value.denominator.fdiv(@value.denominator + @value.numerator)
      end

      # Calculate profit for a wager.
      # 
      # @return [Float, Integer]
      def calculate_profit(amount)
        @value * amount
      end

    end
  end
end
