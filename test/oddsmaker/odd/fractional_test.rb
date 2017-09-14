require "test_helper"

class FractionalTest < Minitest::Test

  def test_it_initializes_with_a_name
    odd = Oddsmaker::Odd::Fractional.new('1/2', 'favorite')
    assert_equal 'favorite', odd.id
    assert_equal 'favorite', odd.name
  end

  def test_it_initializes_strings
    value = '1/2'
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal 1.0/2, odd.value
  end

  def test_it_initializes_floats
    value = 1.0/2
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal 1.0/2, odd.value
  end

  def test_it_initializes_rationals
    value = 1/2.rationalize
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal 1.0/2, odd.value
  end

  def test_it_self_references
    value = 1.0/2
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal odd, odd.fractional
  end

  def test_it_overrounds
    odd = Oddsmaker::Odd::Fractional.new(1.0/2)
    over = Oddsmaker::Odd::Fractional.new(0.5/2)
    assert_equal over, odd.overround!(20)
  end

  def test_it_prints_string
    value = 1.0/2
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal '1/2', odd.to_s
  end

  def test_it_converts_to_american
    value = 1.0/2
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal Oddsmaker::Odd::American.new(-200), odd.american
  end

  def test_it_converts_to_decimal
    value = 1.0/2
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal Oddsmaker::Odd::Decimal.new(1.5), odd.decimal
  end

  def test_it_calculates_multiplier
    value = 1.0/2
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal Oddsmaker::Odd::Decimal.new(1.5).value, odd.multiplier
  end

  def test_it_calculates_probability
    value = 1.0/2
    odd = Oddsmaker::Odd::Fractional.new(value)
    assert_equal 2.0/3, odd.implied_probability.value
  end

end
