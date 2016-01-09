require 'shopee'
require 'json'


class ShopeeWorker
  def initialize(id=nil)

  end

  def search_by_name_cate(cate, name, num)
    cshopeecate = ShopeeScrape::ShopeeListGoodsByCate.new()
    cshopeecate.search_keyword(cate, name, num)
  end
end
