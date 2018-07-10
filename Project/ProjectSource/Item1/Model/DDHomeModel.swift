//
//  DDHomeModel.swift
//  Project
//
//  Created by WY on 2017/12/5.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit


class test : NSObject , Decodable {
    var isNeedJudge: Bool = false
    var actionKey: String = ""
    var keyParameter: Any? = nil
    private enum CodingKeys: String, CodingKey  {
        case isNeedJudge
        case actionKey
        case keyParameter
    }
    
    required init(from decoder: Decoder) throws{
        var container = try decoder.container(keyedBy: CodingKeys.self)
        isNeedJudge = try container.decode(type(of: isNeedJudge), forKey: test.CodingKeys.isNeedJudge)
        //           var container =  try decoder.container(keyedBy: CodingKeys.self)
        //        var container = decoder.container(keyedBy: CodingKeys.self)
        //            try container.decode(isNeedJudge, forKey:.isNeedJudge)
        //        try container.decode(isNeedJudge, forKey: DDActionModel.CodingKeys.isNeedJudge)
    }
}
class DDHomeApiModel: NSObject , Codable{
    var status : Int = 0
    var message : String = ""
    var data  = HomeDataModel()
    
    
}
//class BBBB: NSObject , Codable {
//    var a = 0
//}
//func asaaa()  {
//    DDDecode(ApiModel<BBBB>.self, from: nil )
//}
class DDActionModel: NSObject , DDShowProtocol {
    var isNeedJudge: Bool = false
    var actionKey: String = ""
    var keyParameter: Any? = nil
//    private enum CodingKeys: String, CodingKey  {
//        case isNeedJudge
//        case actionKey
//        case keyParameter2
//    }
//
//    required init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        isNeedJudge = try container.decode(type(of: isNeedJudge), forKey: DDActionModel.CodingKeys.isNeedJudge)
//        actionKey = try container.decode(type(of: actionKey), forKey: DDActionModel.CodingKeys.actionKey)
//        keyParameter = try container.decode(type(of: keyParameter), forKey: DDActionModel.CodingKeys.keyParameter)
//    }
}
///data模型
class HomeDataModel   : NSObject , Codable{
    var hotSearch : [DDHotSearchModel] = [DDHotSearchModel]()
    var channelMenu : [DDChannelMenuModel] = [DDChannelMenuModel]()
    var hotRecom : [DDHotRecom] = [DDHotRecom]()
    var nearbyComments : [DDHotComment]? = [DDHotComment]()
    var hudong : [DDHuDong] = [DDHuDong]()
}
///热门搜索
class DDHotSearchModel:  DDActionModel , Codable{
//    var xxxx : String = ""
    var id :  Int   = 0
    var keyword : String = ""
//    private enum CodingKeys: String, CodingKey  {
//        case id
//        case keyword
//    }
//
//    required init(from decoder: Decoder) throws{
//        try super.init(from:decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        keyword = try container.decode(type(of: keyword), forKey: DDHotSearchModel.CodingKeys.keyword)
//        id = try container.decode(type(of: id), forKey: DDHotSearchModel.CodingKeys.id)
//        //           var container =  try decoder.container(keyedBy: CodingKeys.self)
//        //        var container = decoder.container(keyedBy: CodingKeys.self)
//        //            try container.decode(isNeedJudge, forKey:.isNeedJudge)
//        //        try container.decode(isNeedJudge, forKey: DDActionModel.CodingKeys.isNeedJudge)
//    }
}
///频道菜单
class DDChannelMenuModel:  DDActionModel ,Codable {
    var id : Int   = 0
    var name : String = ""
    var channel_id :  Int   = 0
    var image_url = ""
    
}
///热门推荐
class DDHotRecom : DDActionModel , Codable {
    var id :  Int   = 0
//    var recom_word : String = ""
//    var type : Int   = 0
//    var item_id :  Int   = 0
//    var image_url = ""
    var article_image  = ""
//    var intro = ""//comment
    
    
    var article_desc = ""
    var article_id : Int = 0
    var article_name = "title"
    var channel : Int?  = 0
    
}

///互动
class DDHuDong: DDActionModel,Codable {
//    enum CodingKeys : String ,CodingKey {
//        case relation_id = "relation_id"
//        case type
//        case nikename
//        case hd_title
//        case hd_name
//    }
//    required init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self )
//        do {
//            //relation_id服务器返回的数据类型即可能是int(值为0时) 同时又可能是string(值不为0时)
//            let num_relation_id = try container.decode(Int?.self, forKey: DDHuDong.CodingKeys.relation_id)
//            relation_id = "\(num_relation_id ?? 0)"
//            mylog(num_relation_id)
//        } catch   {
//            mylog(error )
//        }
//        do {
//            let string_relation_id = try container.decode(String?.self, forKey: DDHuDong.CodingKeys.relation_id)
//            relation_id = string_relation_id
//        } catch   {
//            mylog(error )
//        }
//
////       let num_relation_id = try container.decode(Int?.self, forKey: DDHuDong.CodingKeys.relation_id)
////        mylog(num_relation_id)
//        nikename = try container.decode(String.self, forKey: DDHuDong.CodingKeys.nikename)
//       type = try container.decode(Int.self, forKey: DDHuDong.CodingKeys.type)
//       hd_title = try container.decode(String.self, forKey: DDHuDong.CodingKeys.hd_title)
//       hd_name = try container.decode(String.self, forKey: DDHuDong.CodingKeys.hd_name)
//    }
//    func encode(to encoder: Encoder) throws{
//        var container =  encoder.container(keyedBy: CodingKeys.self )
//        try container.encode(nikename, forKey: DDHuDong.CodingKeys.nikename)
//        try container.encode(relation_id, forKey: DDHuDong.CodingKeys.relation_id)
//        try container.encode(type, forKey: DDHuDong.CodingKeys.type)
//        try container.encode(hd_title, forKey: DDHuDong.CodingKeys.hd_title)
//        try container.encode(hd_name, forKey: DDHuDong.CodingKeys.hd_name)
//    }

    var relation_id : Int?
    var type : Int = 0
    var nikename:String  = ""
    var hd_title: String? = ""
    var hd_name:String? = ""
}


///附近评论
class DDHotComment: DDActionModel,Codable {
    var id : Int =  0
    var shop_id : Int = 0
    var shop_name:String  = ""
    var member_id:Int =  0
    var member_name: String = ""
    var time:Int = 0 // 时间戳
    var content:String = "" //评论内容
    var ios_location : DDCoordinate = DDCoordinate()
    var ios_gj_location: DDCoordinate  = DDCoordinate()
}

class DDCoordinate: NSObject , Codable {
    var lon : String = ""
    var lat : String  =  ""
}


class DDNearbyApiModel: NSObject , Codable{
        var status : Int = 0
        var message : String = ""
//    var message : Bool = false
        var data  = DDNearbyApiDataModel()
}

class DDNearbyApiDataModel: NSObject , Codable{
    var p : String = "" 
    var tail:Int = 1
    var shops : [DDNearbyShopModel]? = [DDNearbyShopModel]()
    
}

class DDNearbyShopModel: DDActionModel , Codable {
    var  id : Int = -1
    var  name : String = ""
    var  score : String  =  ""
    var  type : Int =  -1
    var  dispatching : Int =  -1
    var  online_pay :  Int = -1
    var  average_consume : Int =  -1
    var  label : String? =  ""
    var  sort :  CGFloat = -1
    var  front_image :  String = ""
    var type_name : String? = ""
}


///自己组合模型数据
class DDItemModel: NSObject {
    var classIdentify = ""
    var items : [DDActionModel] = [DDActionModel]()
    
}

