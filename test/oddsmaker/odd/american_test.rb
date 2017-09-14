require "test_helper"

class AmericanTest < Minitest::Test

  def test_it_initializes_with_a_name
    value = '-150'
    odd = Oddsmaker::Odd::American.new(value, 'favorite')
    assert_equal 'favorite', odd.id
    assert_equal 'favorite', odd.name
  end

  def test_it_initializes_positive_odd
    value = '+150'
    odd = Oddsmaker::Odd::American.new(value)
    assert_equal 150, odd.value
  end

  def test_it_initializes_negative_odd
    value = '-150'
    odd = Oddsmaker::Odd::American.new(value)
    assert_equal -150, odd.value
  end

  def test_it_self_references
    value = '-150'
    odd = Oddsmaker::Odd::American.new(value)
    assert_equal odd, odd.american
  end

  def test_it_overrounds
    odd = Oddsmaker::Odd::American.new(-100)
    over = Oddsmaker::Odd::American.new(-110)
    assert_equal over, odd.overround!(5)
  end

  def test_it_prints_positive
    odd = Oddsmaker::Odd::American.new(150)
    assert_equal '+150', odd.to_s
  end

  def test_it_prints_negative
    odd = Oddsmaker::Odd::American.new(-150)
    assert_equal '-150', odd.to_s
  end

  def test_it_calculates_probability
    value = '-150'
    odd = Oddsmaker::Odd::American.new(value)
    assert_equal 0.6, odd.implied_probability.value.round(3)
    value = '+150'
    odd = Oddsmaker::Odd::American.new(value)
    assert_equal 0.4, odd.implied_probability.value
  end

  def test_it_converts_to_decimal
    odd = Oddsmaker::Odd::American.new(-200)
    assert_equal Oddsmaker::Odd::Decimal.new(1.5), odd.decimal
  end

  def test_it_calculates_multiplier
    odd = Oddsmaker::Odd::American.new(-200)
    assert_equal Oddsmaker::Odd::Decimal.new(1.5).value, odd.multiplier
  end

  def test_it_converts_negative_to_fractional
    odd = Oddsmaker::Odd::American.new(-200)
    assert_equal Oddsmaker::Odd::Fractional.new(1.0/2), odd.fractional
  end

  def test_it_converts_positive_to_fractional
    odd = Oddsmaker::Odd::American.new(200)
    assert_equal Oddsmaker::Odd::Fractional.new(2.0), odd.fractional
  end

  def test_it_calculates_positive_profit
    odd = Oddsmaker::Odd::American.new(200)
    assert_equal 200, odd.profit(100)
  end

  def test_it_calculates_negative_profit
    odd = Oddsmaker::Odd::American.new(-200)
    assert_equal 100, odd.profit(200)
  end

end
