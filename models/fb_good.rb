require 'second_handler'
require 'json'
class FbGood 
    attr_reader :fid, :token, :action, :post_handler
    def initialize(fid, token=nil, action=nil)
        @token = token
        @action = action.nil? ? nil : action.to_sym
        @fid = fid
        @post_handler = SecondHandler::FbSinglePost.new("1517291225230751|o7NH0AUs5hiQRZpCTq2Q_9gZf0w",@fid)
    end
    def good_info_json
        @post_handler.get_post_basic.to_json
    end
    def comments_json
        if @token.nil? or  @action.nil?
            @post_handler.first_comment
        else
            @post_handler.specified_comment(@token, @action)
        end
        
        next_path = @post_handler.next_page_comment_params
        prev_path = @post_handler.previous_page_comment_params
        res  = Hash.new
        res["data"] = @post_handler.get_comment.to_json
        res["after"] = next_path.nil? ? nil: next_path.last["after"]
        res["before"] = prev_path.nil? ? nil: prev_path.last["before"]
        
        res.to_json
    end

    
end