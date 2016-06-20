def update_quality(items)
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

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
