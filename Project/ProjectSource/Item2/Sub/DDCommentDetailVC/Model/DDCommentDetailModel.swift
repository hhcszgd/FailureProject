//
//  DDCommentDetailModel.swift
//  Project
//
//  Created by WY on 2017/12/24.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCommentDetailModel: NSObject {

}

class DDCommentDetailApiModel: NSObject , Codable {
    var status : Int   = 0
    var message = ""
    var data : [CommentMember] = [CommentMember]()
}

class CommentMember: NSObject , Codable{
    var achieve : [DDAchieve]?
    var content = ""
    var create_at = ""
    var good_number : String  = ""
    var head_img = ""
    var images : [DDCommentMedia]?
    var level : String  = ""
    var member_id : String  = ""
    var nickname = ""
    var shop_name = ""
}

class DDAchieve: NSObject , Codable {
    var achieve_name = ""
    var achieve_smallimg = ""
}
class DDCommentMedia: NSObject , Codable {
    var image_url : String?
    var type : String  = ""
    var video_url : String?
}


class CommentListApiModel: NSObject , Codable {
    var status : Int   = 0
    var message = ""
    var data : [ReplyMember]?
}

class ReplyMember: NSObject , Codable{
    var content : String = ""
    var id : String  = ""
    var member_avatar = ""
    var member_id : String  = ""
    var member_name = ""
    var reply : [ReplyModel]?
}

class ReplyModel : NSObject,Codable {
    var content = ""
    var id : String  = ""
    var member_avatar = ""
    var member_id : String  = ""
    var member_name = ""
    var reply_member_id : String?
    var reply_member_name : String?
}
