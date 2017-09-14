require "test_helper"

class WagerTest < Minitest::Test

  def test_it_calculates_american_profit
    amount = 150
    odds = Oddsmaker::Odd::American.new(-amount)
    wager = Oddsmaker::Wager.new(amount, odds)
    assert_equal 100, wager.profit
    assert_equal odds.profit(amount), wager.profit
    assert_equal odds.profit(amount) + amount, wager.return
  end

  def test_it_calculates_decimal_profit
    amount = 100
    odds = Oddsmaker::Odd::Decimal.new('1.5')
    wager = Oddsmaker::Wager.new(amount, odds)
    assert_equal 50, wager.profit
    assert_equal odds.profit(amount), wager.profit
    assert_equal odds.profit(amount) + amount, wager.return
  end

  def test_it_calculates_fractional_profit
    amount = 100
    odds = Oddsmaker::Odd::Fractional.new('1/2')
    wager = Oddsmaker::Wager.new(amount, odds)
    assert_equal 50, wager.profit
    assert_equal odds.profit(amount), wager.profit
    assert_equal odds.profit(amount) + amount, wager.return
  end

  def test_it_converts_to_hash
    amount = 150
    odds = Oddsmaker::Odd::American.new(-amount)
    wager = Oddsmaker::Wager.new(amount, odds)
    hash = wager.to_h
    assert_equal 150, hash[:amount]
    assert_equal 100, hash[:profit]
    assert_equal 250, hash[:return]
  end

  def test_it_converts_to_json
    amount = 150
    odds = Oddsmaker::Odd::American.new(-amount)
    wager = Oddsmaker::Wager.new(amount, odds)
    json = wager.to_json
    assert_kind_of String, json
    hash = JSON.parse(json)
    assert_equal 150, hash['amount']
    assert_equal 100, hash['profit']
    assert_equal 250, hash['return']
  end

end
