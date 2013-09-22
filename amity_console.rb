require_relative 'item_extractor'

class AmityConsole
  def initialize
    @ex = ItemExtractor.new
  end


  def print_all(item)
    print_info(item)
    print_shops(item)
  end


  def print_info(item)
    info = @ex.get_item_info(search(item))
    puts "#{info[:name]}\tØWeek #{info[:avg_week]}\tØTotal #{info[:avg_total]}"
  end

  def print_shops(item)
    shops = @ex.get_shops_on(search(item))
    shops.each do |shop|
      puts "#{shop[:price]}z\t #{shop[:amount]}ea\tName: #{shop[:name]}"
    end
  end


  def search(term)
    unless term.to_s =~ /^[0-9]+$/
      item_ids = @ex.get_id(term)

      #just use the first result
      result_id = item_ids[0][:id]

      #use the id of an exact match instead
      item_ids.each do |item|
        if item.has_value?(item[:name].capitalize)
          result_id = item[:id]
        end
      end
      result_id
    else

    return term
    end
  end
end
