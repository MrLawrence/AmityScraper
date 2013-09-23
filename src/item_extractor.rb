require 'rubygems'
require 'open-uri'
require 'cgi'
require 'nokogiri'

# scraps market information for items from amity-guild.de
#
#
class ItemExtractor
  def initialize
    @search_query = 'http://www.amity-guild.de/?searchstring='
  end

  def get_id(string)
    doc = Nokogiri::HTML(open(@search_query + CGI.escape(string)))
    items_doc = doc.css('table.results > tr[class]')

    items = []
    items_doc.each do |doc_element|
      name = doc_element.css('a.resultlink').text
      id = doc_element.attr('onclick')[/item([0-9]*)'/, 1]
      items << {id: id,
                name: name}
    end

    items
  end

  def get_name(id)
    filter_doc_for_id(id, 'span.itemname').text
  end

  def get_item_info(id)
    doc_stats = filter_doc_for_id(id, 'div#item_info td.ta_r')
    stats = doc_stats.map(&:text)
    stats = stats | stats[3].split('with scam')
    stats.map! { |e| e.gsub(/\u00A0/, '').gsub(/ z/, '').strip }

    {amount: stats[1],
     avg_week: stats[2],
     avg_total: stats[5],
     avg_total_scam: stats[6],
     oc_price: stats[4]}
  end

  def get_shops_on(id)
    shops_on = filter_doc_for_id(id, 'tr:has(td.status.on):not(:has(td > div.off.zusatz))')
    shops = []
    shops_on.each do |shop|
      shop_id = shop.attr('onclick')[/shop([0-9]*)'/, 1].strip
      values = shop.css('td').map(&:text)

      shops << {id: shop_id,
                name: values[2].strip,
                price: values[3].gsub(/ Zeny/, '').strip,
                amount: values[4].gsub(/ ea/, '').strip}
    end

    shops
  end

  private

  def filter_doc_for_id(id, term)
    doc = Nokogiri::HTML(open(@search_query + 'item' + id))
    doc.css(term)
  end

end
