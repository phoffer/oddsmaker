# Oddsmaker

Oddsmaker is to represent and manipulate betting odds. Multiple odds can be represented together, as a `Market`. A `Market` is able to calculate total probability and vig, and can also calculate true probabilities (total of 100%) and calculate overrounded odds (greater than 100%).

Oddsmaker can handle American odds, decimal odds, fractional odds, and implied probability, and allows for easy conversion between all of those types.

[SportsBookReview](https://www.sportsbookreview.com/picks/tools/odds-converter/) has an excellent page which explains the different types of odds and converts between them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oddsmaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oddsmaker

## Usage

Let's start with a simple odd:

```ruby
# create an Odd
odd = Oddsmaker::Odd.american(300)  # => <Oddsmaker::Odd::American @id=300, @value=300>
odd = Oddsmaker::Odd.american('+300', 'underdog')  # optional 2nd param allows for identifying the odd
odd       # => <Oddsmaker::Odd::American @id="underdog", @value=300>
odd.name  # => "underdog"
odd.value # => 300
odd.to_s  # => "+300"

# can convert between formats
odd.decimal               # => <Oddsmaker::Odd::Decimal @id="underdog, @value=4.0>
odd.fractional            # => <Oddsmaker::Odd::Fractional @id="underdog, @value=(3/1)>
odd.implied_probability   # => <Oddsmaker::Odd::ImpliedProbability @id="underdog", @value=0.25>

# easy creation any type of odd
# any odd type can be compared as well
Oddsmaker::Odd.american(300) == Oddsmaker::Odd.decimal(4)
Oddsmaker::Odd.decimal(4) == Oddsmaker::Odd.fractional(3/1)
Oddsmaker::Odd.fractional(3/1) == Oddsmaker::Odd.implied(25)
Oddsmaker::Odd.implied(25) == Oddsmaker::Odd.american(300)

Oddsmaker::Odd.american(300, 'underdog').to_json # => {"name":"underdog","american":300,"decimal":4.0,"fractional":"3/1","implied":0.25}
```

A collection of `Odd`s can be represented as a `Market`:

```ruby
# Create a Market with odds as the arguments
market = Oddsmaker::Market.new(Oddsmaker::Odd.american(300), Oddsmaker::Odd.american(-400))
market.total_probability    # => 1.05
market.vig                  # => 0.04761904761904767 (equivalent to (1 - total_probability**-1))

# get the odds without vig
no_vig = market.without_vig   # => new market with the vig/overround removed
no_vig.odds                   # => [#<Oddsmaker::Odd::American @id=300, @value=320>, #<Oddsmaker::Odd::American @id=-400, @value=-320>]
no_vig.total_probability      # => 1.0
no_vig.vig                    # => 0

# apply an overround to have vigged odds
vigged = no_vig.overround!(5) # => 5% overround, returns a new Market
vigged.odds                   # => [#<Oddsmaker::Odd::American @id=300, @value=300>, #<Oddsmaker::Odd::American @id=-400, @value=-400>]
vigged.total_probability      # => 1.05
vigged.vig                    # => 0.04761904761904767

vigged == market              # => true # equality comparison only cares about the odds' values. Name and ordering is not relevant
```

There is also functionality for calculating wagers:

```ruby
odd = Oddsmaker::Odd.american(300)  # => <Oddsmaker::Odd::American @id=300, @value=300>
wager = odd.wager(100)              # => <Oddsmaker::Wager @amount=100, @odd=#<Oddsmaker::Odd::American @id=300, @value=300>>
wager.amount                        # => 100
wager.profit                        # => 300
wager.return                        # => 400

# odds are able to calculate their own profit for a wager amount
odd.profit(100)                     # => 300
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/phoffer/oddsmaker.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
