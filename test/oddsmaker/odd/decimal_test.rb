require "test_helper"

class DecimalTest < Minitest::Test

  def test_it_initializes_with_a_name
    odd = Oddsmaker::Odd::Decimal.new('1.5', 'favorite')
    assert_equal 'favorite', odd.id
    assert_equal 'favorite', odd.name
  end

  def test_it_initializes_strings
    odd = Oddsmaker::Odd::Decimal.new('1.5')
    assert_equal 1.5, odd.value
  end

  def test_it_self_references
    odd = Oddsmaker::Odd::Decimal.new(1.5)
    assert_equal odd, odd.decimal
  end

  def test_it_calculates_multiplier
    odd = Oddsmaker::Odd::Decimal.new(1.5)
    assert_equal odd.value, odd.multiplier
  end

  def test_it_overrounds
    odd = Oddsmaker::Odd::Decimal.new(2.0)
    assert_equal 1.818, odd.overround!(10).value.round(3)
  end

  def test_it_prints_string
    odd = Oddsmaker::Odd::Decimal.new(1.5)
    assert_equal '1.5', odd.to_s
  end

  def test_it_converts_to_american
    odd = Oddsmaker::Odd::Decimal.new(1.5)
    assert_equal Oddsmaker::Odd::American.new(-200), odd.american
  end

  def test_it_converts_to_fractional
    odd = Oddsmaker::Odd::Decimal.new(1.5)
    assert_equal Oddsmaker::Odd::Fractional.new(1/2.rationalize), odd.fractional
  end

  def test_it_calculates_probability
    odd = Oddsmaker::Odd::Decimal.new(1.5)
    assert_equal 2.0/3, odd.implied_probability.value
  end

end
