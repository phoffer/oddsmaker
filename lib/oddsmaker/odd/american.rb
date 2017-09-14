module Oddsmaker
  module Odd
    # American Odds class, handling both positive and negative odds.
    # A negative value expresses the dollar amount that would need to be wagered in order to win $100.
    # A positive number expresses the dollar amount that would be won from a $100 wager, excluding the original wager.
    class American < Base

      def initialize(value, id = nil)
        @id    = id || value
        @value = value.to_i
      end

      # Properly display both positive and negative odds.
      # 
      # @return [String]
      def to_s
        @value.positive? ? "+#{@value}" : @value.to_s
      end

      # Returns self. This creates a consistent API for all odds.
      # 
      # @return [self]
      def american
        self
      end

      # Convert to decimal odds, returning a new object.
      # 
      # @return [Decimal]
      def decimal
        @decimal ||= implied_probability.decimal
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
        :american
      end

      # Calculate implied probability of an odd.
      # 
      # @return [Float]
      def calculate_probability
        calculate_probability ||= if @value.positive?
          100.0 / (@value + 100)
        else
          -@value.to_f / (100 - @value)
        end
      end

      # Calculate fractional representation of an odd.
      # 
      # @return [Float]
      def calculate_fractional
        calculate_fractional ||= if @value.positive?
          @value / 100.rationalize
        else
          -100 / @value.rationalize
        end
      end

      # Calculate profit for a wager.
      # 
      # @return [Float, Integer]
      def calculate_profit(amount)
        if @value.positive?
          (amount/100.rationalize) * @value
        else
          -100/@value.rationalize * amount
        end
      end

    end
  end
end
