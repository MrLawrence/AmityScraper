require 'nokogiri'
require 'open-uri'


class ItemExtractor
  def initialize
    @search_query = 'http://www.amity-guild.de/?searchstring='
  end

  def get_item_info(string)

    doc = get_item_doc(string)

    name = doc.css('div.pagecontent > div.item_detail_title > div.left > span.itemname').text

    stats = doc.css('div.pagecontent > div#item_info > div > table > tr.zero > td.ta_r').map(&:text)
    stats.map! do |e|
      e.gsub(/ z/, '').strip
    end
    avg_total = stats[3].split('with scam')
    avg_total.map! do |e|
      e.gsub(/\u00A0/, '').strip
    end


    {
        name: name,
        amount: stats[1],
        avg_week: stats[2],
        avg_total: avg_total[0],
        avg_total_scam: avg_total[1],
        oc_price: stats[4]
    }
  end

  def get_shops_on(string)
    doc = get_item_doc(string)
    shops_on = doc.css('div.pagecontent > table.results > tr[class]:has(td.status.on):not(:has(td[class] > div.off.zusatz))')

    shops = Array.new
    shops_on.each do |shop|
      shop_id = shop.attr('onclick')[/shop([0-9]*)\'/, 1].strip
      values = shop.css('td').map(&:text)

      shops << {
          id: shop_id,
          name: values[2].strip,
          price: values[3].gsub(/ Zeny/, '').strip,
          amount: values[4].gsub(/ ea/, '').strip
      }
    end

    return shops
  end

  private


  def get_id(string)
    doc = Nokogiri::HTML(open(@search_query + string.gsub(' ','%20')))
    items_doc = doc.css('div.pagecontent > table.results > tr[class]')

    items = Array.new
    items_doc.each do |doc_element|
      name = doc_element.css('a.resultlink').text
      id = doc_element.attr('onclick')[/item([0-9]*)\'/, 1]
      items << {
          id: id,
          name: name
      }
    end

    #just use the first result
    found_id = items[0][:id]

    #use the id of an exact match instead
    items.each do |item|
      if item.has_value?(string.capitalize)
        found_id = item[:id]
      end
    end

    return found_id
  end

  def get_item_doc(string)
    string = get_id(string) unless string.to_s =~ /^[0-9]+$/

    return doc = Nokogiri::HTML(open(@search_query + 'item' + string))
  end

end