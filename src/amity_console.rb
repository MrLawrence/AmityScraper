require_relative 'item_extractor'

class AmityConsole
  def initialize
    @ex = ItemExtractor.new
  end


  def print_all(item)
    print_name(item)
    print_info(item)
    print_shops(item)
  end


  def print_name(item)
    puts @ex.get_name(item)
  end

  def print_info(item)
    info = @ex.get_item_info(search(item))
    puts "ØWeek #{info.fetch(:avg_week)}\tØTotal #{info.fetch(:avg_total)}"
  end

  def print_shops(item)
    shops = @ex.get_shops_on(search(item))
    shops.each do |shop|
      puts "#{shop.fetch(:price)}z\t #{shop.fetch(:amount)}ea\tName: #{shop.fetch(:name)}"
    end
  end


  def search(term)
    if term.to_s =~ /^[0-9]+$/
      term
    else
      item_ids = @ex.get_id(term)

      #just use the first result
      result_id = item_ids[0].fetch(:id)

      #use the id of an exact match instead
      item_ids.each do |item|
        if item.has_value?(item.fetch(:name).capitalize)
          result_id = item.fetch(:id)
        end
      end
      result_id
    end
  end
end
