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
    puts cate
    shopeecate = ShopeeScrape::ShopeeListGoodsByCate.new(cate, page)
    shopeecate.goods
  end

  def get_cate_childs(cate)
    cshopeecate = ShopeeScrape::ShopeeListGoodsByCate.new()
    cshopeecate.get_cate_childs(cate)
  end
end
