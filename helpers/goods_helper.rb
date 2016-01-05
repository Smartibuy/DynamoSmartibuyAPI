#This module is for selling goods operation

module GoodsHelpers
  def get_all_information(id,timestamp=nil, page=nil)
      Goods.new(id, page, timestamp)
   
  end
  
  
  def get_good(group_id, good_id)
      Goods.new(group_id).get_good_by_id(good_id)
    rescue
      halt 404
  end
end
