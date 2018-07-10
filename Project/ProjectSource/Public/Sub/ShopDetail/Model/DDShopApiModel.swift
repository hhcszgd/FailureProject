//
//  DDShopApiModel.swift
//  Project
//
//  Created by WY on 2017/12/19.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDShopApiModel: NSObject,Codable {
    var status  : Int = 0
    var message = ""
    var data  : [DDShopApiDataModel] = [DDShopApiDataModel]()
}
class DDShopApiDataModel: NSObject , Codable {
    var id : String = ""
    var shop_classify_id = ""
    var shop_name = ""
    var average_consume  = ""
    var shop_lon = ""
    var shop_lat = ""
    var shop_gj_lon = ""
    var shop_gj_lat = ""
    var shop_classify_name  = ""
    var shop_score = ""
    var address = ""
    var contacts = ""
    var mobile = ""
    var business_day = ""
    var business_time = ""
    var services = ""
    var follow_number = ""
    var imgs : [DDShopTopImgModel] = [DDShopTopImgModel]()
    var goods : [DDShopGoodsModel] = [DDShopGoodsModel]()
    var binding : [DDShopBindingModel] = [DDShopBindingModel]()
    var comment : [DDShopCommentModel] = [DDShopCommentModel]()
}
class DDShopTopImgModel: NSObject , Codable {
    var image_url = ""
}
class DDShopGoodsModel: NSObject  , Codable {
    var goods_name = ""
    var goods_price = ""
    var goods_img = ""
}
class DDShopBindingModel: NSObject  , Codable {
    var value = ""
}

class DDShopCommentModel : NSObject , Codable {
    var id = ""
    var member_id = ""
    var member_name = ""
    var content = ""
    var create_at = ""
    var good_number = ""
    var nickname = ""
    var head_img = ""
    var level = ""
    var achieve : [DDShopAchieveModel] = [DDShopAchieveModel]()
    var images : [DDShopImageModel]? = [DDShopImageModel]()
}
class DDShopAchieveModel: NSObject  , Codable {
    var achieve_name = ""
    var achieve_smallimg = ""
}

class DDShopImageModel: NSObject , Codable {
    var image_url : String? = ""
}
