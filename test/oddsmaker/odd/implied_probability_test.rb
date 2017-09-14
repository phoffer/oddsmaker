require "test_helper"

class ImpliedProbabilityTest < Minitest::Test

  def test_it_initializes_with_a_name
    odd = Oddsmaker::Odd::ImpliedProbability.new(75, 'favorite')
    assert_equal 'favorite', odd.id
    assert_equal 'favorite', odd.name
  end

  def test_it_prints_string
    value = 75
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal '0.75', odd.to_s
  end

  def test_it_self_references
    value = 75
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal odd, odd.implied_probability
  end

  def test_it_compares_equality
    value = 75
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal odd, odd.american
    assert_equal odd.american, odd
  end

  def test_it_overrounds
    odd = Oddsmaker::Odd::ImpliedProbability.new(75)
    over = Oddsmaker::Odd::ImpliedProbability.new(82.5)
    assert_equal over.value.round(2), odd.overround!(10).value.round(2) # TODO fix floating point math error with this
  end

  def test_it_is_self_aware
    odd = Oddsmaker::Odd::ImpliedProbability.new(75)
    assert_equal odd, odd.implied_probability
    assert_equal :implied_probability, odd.send(:type)
  end

  def test_it_calculates_decimal
    value = 75
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal 4.0/3, odd.decimal.value
    assert_instance_of Oddsmaker::Odd::Decimal, odd.decimal
  end

  def test_it_calculates_multiplier
    value = 75
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal 4.0/3, odd.multiplier
  end

  def test_it_calculates_american_even
    value = 50
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal -100, odd.american.value
    assert_instance_of Oddsmaker::Odd::American, odd.american
  end

  def test_it_calculates_american_negative
    value = 75
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal -300, odd.american.value
    assert_instance_of Oddsmaker::Odd::American, odd.american
  end

  def test_it_calculates_american_positive
    value = 25
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal 300, odd.american.value
    assert_instance_of Oddsmaker::Odd::American, odd.american
  end

  def test_it_calculates_fractional_low
    value = 25
    odd = Oddsmaker::Odd::ImpliedProbability.new(value)
    assert_equal 3, odd.fractional.value
    assert_instance_of Oddsmaker::Odd::Fractional, odd.fractional
  end

  def test_it_rounds
    value = '-120'
    odd = Oddsmaker::Odd::American.new(value)
    assert_equal 0.55, odd.implied_probability.round
    assert_equal 0.545, odd.implied_probability.round(3)
    assert_equal 0.54545, odd.implied_probability.round(5)
  end

  def test_it_has_percent
    value = '-150'
    odd = Oddsmaker::Odd::American.new(value)
    assert_equal 60, odd.implied_probability.to_percent
  end

  def test_it_rounds_percent
    value = '-120'
    odd = Oddsmaker::Odd::American.new(value)
    assert_equal 54.5, odd.implied_probability.to_percent(1)
    assert_equal 54.545, odd.implied_probability.to_percent(3)
  end


end
