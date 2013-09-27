require_relative 'item_extractor'

class AmityRbot < Plugin

  def initialize
    @ex = ItemExtractor.new
  end

  def help(plugin, topic='')
    'market <item> => returns market info of <item>'
  end

  def privmsg(m)

    m.reply 'incorrect usage. ' + help(m.plugin) unless m.params

    search = m.params.join(' ')

    info = @ex.get_item_info(search)
    m.reply "#{info.fetch(:name)}\tØWeek #{info.fetch(:avg_week)}\tØTotal #{info.fetch(:avg_total)}"

    shops = @ex.get_shops_on(search)
    shops.each do |shop|
      m.reply "#{shop.fetch(:price)}z\t #{shop.fetch(:amount)}ea\tName: #{shop.fetch(:name)}"
    end
  end


end

plugin = AmityRbot.new
plugin.register('market')

