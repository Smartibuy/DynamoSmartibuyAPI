require 'shopee'
require 'json'


class ShopeeWorker
  def initialize(id=nil)

  end

  def search_by_name_cate(cate, name, num)
    cshopeecate = ShopeeScrape::ShopeeListGoodsByCate.new(cate)
    goods = cshopeecate.goods
    cshopeecate.search_keyword(goods, name, num)
  end
end
