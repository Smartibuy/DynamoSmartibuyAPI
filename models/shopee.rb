require 'shopee'
require 'json'


class ShopeeWorker
  def initialize(id=nil)

  end

  def search_by_name_cate(cate, name, num)
    cshopeecate = ShopeeScrape::ShopeeListGoodsByCate.new()
    cshopeecate.search_keyword(cate, name, num)
  end

  def get_mobile01_products(cate, page=1)
    shopeecate = ShopeeScrape::ShopeeListGoodsByCate.new(cate, page)
    shopeecate.goods
  end

end
