require "test_helper"

class MarketTest < Minitest::Test

  def test_it_looks_up_by_name
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(300, 'McGregor'), Oddsmaker::Odd.american(-400, 'Mayweather'))
    assert_equal 300, mark.odd('McGregor').value
    assert_equal -400, mark.odd('Mayweather').value
  end

  def test_it_initializes_with_name
    title = 'Conor McGregor vs Floyd Mayweather'
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(100), Oddsmaker::Odd.american(100), name: title)
    assert_equal title, mark.name
  end

  def test_it_initializes_american
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(100), Oddsmaker::Odd.american(100))
    assert_equal 2, mark.odds.size
  end

  def test_it_raises_on_duped_identifiers
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(100, 'ID'), Oddsmaker::Odd.american(100, 'ID'))
    assert_raises(Exception) { mark.odd('ID') }
  end

  def test_it_calculates_vig
    vigged = Oddsmaker::Market.new(Oddsmaker::Odd.american(300), Oddsmaker::Odd.american(-400))
    assert_equal (1 - 1.05**-1), vigged.vig
  end

  def test_it_calculates_total_probability
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(100), Oddsmaker::Odd.american(100))
    vigged = Oddsmaker::Market.new(Oddsmaker::Odd.american(300), Oddsmaker::Odd.american(-400))
    assert_equal 1, mark.total_probability
    assert_equal 1.05, vigged.total_probability
  end

  def test_it_vigs_american
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(100), Oddsmaker::Odd.american(100))
    vigged = Oddsmaker::Market.new(Oddsmaker::Odd.american(-110), Oddsmaker::Odd.american(-110))
    assert_equal vigged, mark.overround!(5)
  end

  def test_it_vigs_american_odds
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(100), Oddsmaker::Odd.american(100))
    vigged = Oddsmaker::Market.new(Oddsmaker::Odd.american(-110), Oddsmaker::Odd.american(-110))
    assert_equal vigged.odds, mark.overround_odds!(5)
  end

  def test_it_removes_vig_american
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(100), Oddsmaker::Odd.american(100))
    vigged = Oddsmaker::Market.new(Oddsmaker::Odd.american(-110), Oddsmaker::Odd.american(-110))
    assert_equal mark, mark.without_vig
    assert_equal mark, vigged.without_vig
  end

  def test_it_removes_vig_american_odds
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(100), Oddsmaker::Odd.american(100))
    vigged = Oddsmaker::Market.new(Oddsmaker::Odd.american(-110), Oddsmaker::Odd.american(-110))
    assert_equal mark.odds, mark.without_vig.odds
    assert_equal mark.odds, vigged.without_vig.odds
  end

  def test_it_sorts_odds
    sorted = [Oddsmaker::Odd.american(300), Oddsmaker::Odd.american(-400)]
    mark = Oddsmaker::Market.new(*sorted.reverse)
    assert_equal sorted, mark.odds.sort
  end

  def test_it_compares_matching_odds
    odds = [Oddsmaker::Odd.american(300), Oddsmaker::Odd.american(-400)]
    mark = Oddsmaker::Market.new(*odds.reverse)
    sorted = Oddsmaker::Market.new(*odds)
    assert_equal sorted, mark
  end

  def test_it_converts_to_hash
    title = 'Conor McGregor vs Floyd Mayweather'
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(300, 'McGregor'), Oddsmaker::Odd.american(-400, 'Mayweather'), name: title)
    hash = mark.to_h
    assert_equal (1 - 1.05**-1), hash[:vig]
    assert_equal 1.05, hash[:total_probability]
    assert_equal title, hash[:name]
    assert_equal 2, hash[:odds].size
    assert_equal 300, hash[:odds].first[:american]
    assert_equal -400, hash[:odds].last[:american]
  end

  def test_it_converts_to_json
    title = 'Conor McGregor vs Floyd Mayweather'
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(300, 'McGregor'), Oddsmaker::Odd.american(-400, 'Mayweather'), name: title)
    json = mark.to_json
    assert_kind_of String, json
    hash = JSON.parse(json)
    assert_equal (1 - 1.05**-1), hash['vig']
    assert_equal 1.05, hash['total_probability']
    assert_equal title, hash['name']
    assert_equal 2, hash['odds'].size
    assert_equal 300, hash['odds'].first['american']
    assert_equal -400, hash['odds'].last['american']
  end

  def test_it_converts_without_vig_to_json
    mark = Oddsmaker::Market.new(Oddsmaker::Odd.american(150), Oddsmaker::Odd.american(-150))
    json = mark.to_json
    assert_kind_of String, json
    hash = JSON.parse(json)
    assert_equal 1, hash['total_probability']
    assert_equal 0, hash['vig']
  end

end
