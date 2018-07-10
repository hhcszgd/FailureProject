//
//  DDSearchSmartlyApiModel.swift
//  Project
//
//  Created by WY on 2018/4/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

//class DDSearchSmartlyApiModel: NSObject ,Codable{
////    var friends : [DDPartnerModel]?
////
////    ///我的约定【付款方】
////    var userPublishedResults : [DDAppointShrotModel]?
////
////    ///我的约定【收款方】
////    var userAppointedResults : [DDAppointShrotModel]?
////
////    ///公共约定
////    var publicResults : [DDAppointShrotModel]?
//}

class DDAppointShortGroup: NSObject , Codable {
    var type : String?
    var items : [DDAppointShrotModel]?
}

class DDAppointShrotModel: NSObject,Codable {
    var id  : String?
    var orderId  : String?
    var appointmentId : String? = ""
    var price : String? = ""
    var aId : String? = ""
    var aName : String? = ""
    var truePrice : String? = ""
    var title : String? = ""
    var fullName : String? = ""
    var range : String? = ""
    var requirement  : String?
    var createAt  : String?
    
    var nickname  : String?
    var head_images  : String?
    var mobile  : String?
    
    
    ///【0 私密约定 1公开约定】
    var type : String?
    
    ///【1:单约、2:群约】
    var yueType : String?

    /// 2付款 1收
    var user_type : String?
    
}
