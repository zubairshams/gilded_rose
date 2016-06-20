def update_quality(items)
  items.each do |item|
    klass = klass_for(item)
    klass.new(item).update
  end
end

class ItemUpdater
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    update_quality
    @item.quality = 0  if @item.quality < 0
    @item.quality  = 50 if @item.quality > 50
    update_sell_in
  end

  def update_quality
    @item.quality -= @item.sell_in > 0 ? 1 : 2
  end

  def update_sell_in
    @item.sell_in -= 1
  end
end

class AgedBrieUpdater < ItemUpdater
  def update_quality
    @item.quality += @item.sell_in > 0 ? 1 : 2
  end
end

class BackstageUpdater < ItemUpdater
  def update_quality
    @item.quality += if @item.sell_in > 10
                       1
                     elsif item.sell_in > 5
                       2
                     elsif item.sell_in > 0
                       3
                     else
                       - @item.quality
                     end
  end
end

class SulfurasUpdater < ItemUpdater
  def update_quality; end
  def update_sell_in; end
end

class ConjuredUpdater < ItemUpdater
  def update_quality
    2.times {super}
  end
end

def klass_for(item)
  ITEM_UPDATERS[item.name] || ItemUpdater
end

ITEM_UPDATERS = {
  'Aged Brie'                                 => AgedBrieUpdater,
  'Backstage passes to a TAFKAL80ETC concert' => BackstageUpdater,
  'Sulfuras, Hand of Ragnaros'                => SulfurasUpdater,
  'Conjured'                                  => ConjuredUpdater,
}


######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
