require "test_helper"
require 'json'

class BaseTest < Minitest::Test

  def test_it_converts_to_hash
    odd = Oddsmaker::Odd::American.new(-200, 'name')
    hash = odd.to_h
    assert_equal -200, hash[:american]
    assert_equal 1.5, hash[:decimal]
    assert_equal 1.0/2, hash[:fractional]
    assert_equal 2.0/3, hash[:implied]
    assert_equal 'name', hash[:name]
  end

  def test_it_converts_to_json
    odd = Oddsmaker::Odd::American.new(-200, 'name')
    json = odd.to_json
    assert_kind_of String, json
    hash = JSON.parse(json)
    assert_equal -200, hash['american']
    assert_equal 1.5, hash['decimal']
    assert_equal '1/2', hash['fractional']
    assert_equal 2.0/3, hash['implied']
    assert_equal 'name', hash['name']
  end

end
