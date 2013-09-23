require 'rubygems'
require 'test/unit'
require_relative 'test_helper'

class TestItemExtractor < Test::Unit::TestCase
  def setup
    @item_id = '1053' #Strawberry
    @ex = ItemExtractor.new
  end

  def test_get_id
    result = @ex.get_id('e potion')

    assert(result[0].has_key?(:name))
    assert(result[0].has_key?(:id))

    names = []
    result.each do |hash|
      names << hash[:name]
    end
    assert names.include?('Blue Potion')
  end

  def test_get_name
    result = @ex.get_name(@item_id)

    assert_equal("Strawberry",result)
  end

  def test_get_item_info
    result = @ex.get_item_info(@item_id)

    assert(result.has_key?(:amount))
    assert(result.has_key?(:avg_week))
    assert(result.has_key?(:avg_total))
    assert(result.has_key?(:avg_total_scam))
    assert(result.has_key?(:oc_price))

    assert_equal(5, result.size)
  end

  def test_get_shops_on
    result = @ex.get_shops_on(@item_id)

    assert(result[0].has_key?(:id))
    assert(result[0].has_key?(:name))
    assert(result[0].has_key?(:price))
    assert(result[0].has_key?(:amount))

  end
end