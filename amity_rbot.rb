require '/home/rbot/rbot-data/plugins/item_extractor'

class AmityRbot < Plugin

  def initialize
    @ex = ItemExtractor.new
  end

  def help(plugin, topic='')
    'market <item> => returns market info of <item>'
  end

  def privmsg(m)
    unless m.params
      m.reply 'incorrect usage. ' + help(m.plugin)
    end

    search_string = m.params.join(' ')

    info = @ex.get_item_info(search_string)
    m.reply "#{info[:name]}\tØWeek #{info[:avg_week]}\tØTotal #{info[:avg_total]}"

    shops = @ex.get_shops_on(search_string)
    shops.each do |shop|
      m.reply "#{shop[:price]}z\t #{shop[:amount]}ea\tName: #{shop[:name]}"
    end
  end


end

plugin = AmityRbot.new
plugin.register('market')

