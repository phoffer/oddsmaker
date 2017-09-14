module Oddsmaker
  module Odd
    # Implied probability is the probability of an event, based on the odds for that event.
    # Implied probability is what translates between various types of odds.
    class ImpliedProbability < Base

      def initialize(value, id = nil)
        @id    = id || value
        @value = value >= 1 ? value.fdiv(100) : value
      end

      # Calculates a new odd, removing the vig.
      # 
      # @return [ImpliedProbability]
      def without_vig(total_probability)
        self.class.new(@value / total_probability, id)
      end

      # Calculates a new odd, with the given overround percentage.
      # 
      # @param v [Integer] Overround percentage (as whole number)
      # @return [ImpliedProbability]
      def overround!(v)
        self.class.new(@value * ((100 + v)/100.rationalize), id)
      end

      # Convert probability to percent.
      # Optionally round the resulting decimal.
      # 
      # @param n [Integer] Number of decimal places for rounding.
      def to_percent(n = nil)
        n ? (@value * 100).round(n) : @value * 100
      end

      # Round decimal value.
      # 
      # @param n [Integer] Number of decimal places for rounding.
      def round(n = 2)
        @value.round(n)
      end

      # Check two odds for equality.
      # 
      # @param other [ImpliedProbability]
      # @return [Boolean]
      def ==(other)
        if other.is_a?(self.class)
          @value == other.value
        else
          @value == other.implied_probability.value
        end
      end

      # Compare two odds against each other.
      # 
      # @param other [ImpliedProbability]
      # @return [-1,0,1]
      def <=>(other)
        value <=> other.value
      end

      # Returns self. This creates a consistent API for all odds.
      # 
      # @return [self]
      def implied_probability
        self
      end

      # Convert to American odds, returning a new object.
      # 
      # @return [American]
      def american
        @american ||= American.new(calculate_american, id)
      end

      # Convert to decimal odds, returning a new object.
      # 
      # @return [Decimal]
      def decimal
        @decimal ||= Decimal.new(calculate_decimal, id)
      end

      # Convert to fractional odds, returning a new object.
      # 
      # @return [Fractional]
      def fractional
        @fractional ||= Fractional.new(calculate_fractional, id)
      end

      private

      # Allows for implied probability to create a vigged/unvigged odd and convert it back to source format.
      def type
        :implied_probability
      end

      # Calculate American odds value.
      # 
      # @return [Integer, Float]
      def calculate_american
        value = @value.rationalize
        if value >= 0.5
          - ( value / (1 - value)) * 100
        else
          ((1 - value) / value ) * 100
        end
      end

      # Calculate decimal odds value.
      # 
      # @return [Float]
      def calculate_decimal
        1.0 / @value
      end

      # Calculate fractional odds value.
      # 
      # @return [Rational]
      def calculate_fractional
        (1.0 / @value - 1).rationalize
      end

    end
  end
end
