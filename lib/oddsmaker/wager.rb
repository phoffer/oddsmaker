module Oddsmaker
  # Wager represents an odd and a wagered amount.
  # Odds can directly calculate their profit, so this is just a convenience class.
  class Wager
    attr_reader :amount, :odd

    def initialize(amount, odd)
      @amount = amount
      @odd = odd
    end

    # Calculate profit for a wager.
    # 
    # @return [Float, Integer]
    def profit
      @profit ||= odd.profit(@amount)
    end

    # Calculate return for a wager.
    # Return is profit plus wager amount.
    # 
    # @return [Float, Integer]
    def return
      @return ||= profit + @amount
    end

    # Hash representation of the wager.
    # @return [Hash]
    def to_h
      {
        amount:  self.amount.to_f,
        profit:  self.profit.to_f,
        return:  self.return.to_f,
        odd:     odd.to_h,
      }
    end

    # JSON representation of the wager.
    # @return [String]
    def to_json
      to_h.to_json
    end
  end
end
