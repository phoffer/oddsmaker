module Oddsmaker
  # Odds represent a single value that can be bet on.
  # This can be represented and converted between the various forms it can take:
  # 
  # - Implied probability
  # - Decimal odds
  # - Fractional odds
  # - American odds
  # 
  module Odd

    # Create an implied probability with the given value.
    # 
    # @param value [Float, Integer] Probability value
    # @param id [String] Identifier for this odd. Useful when multiple odds are used in a market
    # @return [ImpliedProbability]
    def self.implied(value, id = nil)
      ImpliedProbability.new(value, id)
    end

    # Create American odds with the given value.
    # 
    # @param value [String, Integer] Odds value
    # @param id [String] Identifier for this odd. Useful when multiple odds are used in a market
    # @return [American]
    def self.american(value, id = nil)
      American.new(value, id)
    end

    # Create decimal odds with the given value.
    # 
    # @param value [Float, Integer] Odds value
    # @param id [String] Identifier for this odd. Useful when multiple odds are used in a market
    # @return [Decimal]
    def self.decimal(value, id = nil)
      Decimal.new(value, id)
    end

    # Create fractional odds with the given value.
    # 
    # @param value [String, Integer] Odds value
    # @param id [String] Identifier for this odd. Useful when multiple odds are used in a market
    # @return [Fractional]
    def self.fractional(value, id = nil)
      Fractional.new(value, id)
    end

    # Shortcut to creating a new odd based off hash params (i.e. request params).
    # Requires one of `%w[american decimal fraction implied]` keys.
    # Also accepts param `'name'`.
    # 
    # @return [Odd]
    def self.new(params = {})
      if (type = %w[american decimal fraction implied].detect { |type| params.key?(type) })
        send(type, params[type], params['name'])
      end
    end

  end
end
