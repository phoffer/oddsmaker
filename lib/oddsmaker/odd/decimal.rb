module Oddsmaker
  module Odd
    # Decimal odds express the amount that would be returned from a $1 wager, including the original wager amount.
    # Decimal odds will always be greater than 1.0.
    class Decimal < Base

      def initialize(value, id = nil)
        @id    = id || value
        @value = value.to_f
      end

      # Returns self. This creates a consistent API for all odds.
      # 
      # @return [self]
      def decimal
        self
      end

      # Convert to American odds, returning a new object.
      # 
      # @return [American]
      def american
        @american ||= implied_probability.american
      end

      # Convert to fractional odds, returning a new object.
      # 
      # @return [Fractional]
      def fractional
        @fractional ||= implied_probability.fractional
      end

      private

      # Allows for implied probability to create a vigged/unvigged odd and convert it back to source format.
      def type
        :decimal
      end

      # Calculate implied probability of an odd.
      # 
      # @return [Float]
      def calculate_probability
        1.0 / @value
      end

      # Calculate profit for a wager.
      # 
      # @return [Float, Integer]
      def calculate_profit(amount)
        (@value - 1) * amount
      end

    end
  end
end
