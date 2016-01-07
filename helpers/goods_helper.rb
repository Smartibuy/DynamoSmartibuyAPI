#This module is for selling goods operation

module GoodsHelpers
  def get_all_information(id,timestamp=nil, page=nil)
      Goods.new(id, page, timestamp)
  end


  def get_good(group_id, good_id)
    begin
      Goods.new(group_id).get_good_by_id(good_id)
    rescue
      halt 404
    end  
  end
  
   def get_one_good(fid,token=nil,action=nil)
     FbGood.new(fid,token,action)
   end
end
