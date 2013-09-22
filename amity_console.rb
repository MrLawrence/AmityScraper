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
    info = @ex.get_item_info(item)
    puts "#{info[:name]}\tØWeek #{info[:avg_week]}\tØTotal #{info[:avg_total]}"
  end

  def print_shops(item)
    shops = @ex.get_shops_on(item)
    shops.each do |shop|
      puts "#{shop[:price]}z\t #{shop[:amount]}ea\tName: #{shop[:name]}"
    end
  end
end
