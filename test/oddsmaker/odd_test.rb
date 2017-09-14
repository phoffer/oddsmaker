require "test_helper"

class OddsTest < Minitest::Test

  def test_it_creates_wager
    assert_instance_of Oddsmaker::Wager, Oddsmaker::Odd.american(100).wager(100)
  end

  def test_it_initializes_from_params
    params = {"american"=>"-150", "name"=>"odd name"}
    assert_equal Oddsmaker::Odd::American.new(-150, "odd name"), Oddsmaker::Odd.new(params)
  end

  def test_it_initializes_american
    value = '-150'
    assert_equal Oddsmaker::Odd::American.new(value), Oddsmaker::Odd.american(value)
  end

  def test_it_initializes_american_with_identifier
    value = '-150'
    assert_equal Oddsmaker::Odd::American.new(value, 'identifier'), Oddsmaker::Odd.american(value, 'identifier')
  end

  def test_it_initializes_decimal
    value = 1.5
    assert_equal Oddsmaker::Odd::Decimal.new(value), Oddsmaker::Odd.decimal(value)
  end

  def test_it_initializes_decimal_with_identifier
    value = 1.5
    assert_equal Oddsmaker::Odd::Decimal.new(value, 'identifier'), Oddsmaker::Odd.decimal(value, 'identifier')
  end

  def test_it_initializes_fractional
    value = '2/3'
    assert_equal Oddsmaker::Odd::Fractional.new(value), Oddsmaker::Odd.fractional(value)
  end

  def test_it_initializes_fractional_with_identifier
    value = '2/3'
    assert_equal Oddsmaker::Odd::Fractional.new(value, 'identifier'), Oddsmaker::Odd.fractional(value, 'identifier')
  end

  def test_it_initializes_implied_probability
    value = 75
    assert_equal Oddsmaker::Odd::ImpliedProbability.new(value), Oddsmaker::Odd.implied(value)
  end

  def test_it_initializes_implied_probability_with_identifier
    value = 75
    assert_equal Oddsmaker::Odd::ImpliedProbability.new(value, 'identifier'), Oddsmaker::Odd.implied(value, 'identifier')
  end

end
