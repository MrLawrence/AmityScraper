require 'rubygems'
require 'test/unit'
require_relative 'test_helper'

class TestItemExtractor < Test::Unit::TestCase
  def setup
    @item = 'Strawberry'
    @ex = ItemExtractor.new
  end

  def test_get_item_info
    result = @ex.get_item_info(@item)

    assert(result.has_key?(:name))
    assert(result.has_key?(:amount))
    assert(result.has_key?(:avg_week))
    assert(result.has_key?(:avg_total))
    assert(result.has_key?(:avg_total_scam))
    assert(result.has_key?(:oc_price))

    assert_equal(6, result.size)

    assert @item == result[:name]
  end

  def test_get_shops_on
    result = @ex.get_shops_on(@item)

    assert(result[0].has_key?(:id))
    assert(result[0].has_key?(:name))
    assert(result[0].has_key?(:price))
    assert(result[0].has_key?(:amount))

  end
end