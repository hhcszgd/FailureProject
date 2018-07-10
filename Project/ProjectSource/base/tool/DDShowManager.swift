//
//  DDShowManager.swift
//  hhcszgd
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
enum Actionkey: String {
    ///空，没有设置
    case 空 = "nil"
    ///账户信息
    case account = "account"
    ///姓名
    case name = "name"
    ///二维码
    case twoDimensionalCode = "two-dimensionalCode"
    ///电话
    case mobile = "mobile"
    ///公司信息
    case companyName = "companyName"
    ///公司电话
    case companyMobile = "companyMobile"
    ///余额
    case balance = "balance"
    ///冻结金额
    case amountOfMoney = "amountOfMoney"
    ///账户明细
    case accountDetails = "accountDetails"
    ///协商列表
    case nogatiationList = "nogatiationList"
    ///设置
    case profileSet = "profileSet"
    ///登录
    case login = "login"
    
}
class DDShowManager {
    class func push(midArr: [String] = [String](), appointmentArr: [String] = [String](), currentVC: UIViewController, finished: @escaping ([DDUserModel]) -> ()) {
      
        
        
        
        
        var paramete: [String: String] = [String: String]()
        let encode = JSONEncoder.init()
        do {
            let midData = try encode.encode(midArr)
            let midStr = String.init(data: midData, encoding: String.Encoding.utf8) ?? ""
            paramete["friends_id"] = midStr
        } catch {
            
        }
        do {
            let data = try encode.encode(appointmentArr)
            let str = String.init(data: data, encoding: String.Encoding.utf8) ?? ""
            paramete["order_id"] = str
        } catch {
            
        }
        
        let router = Router.post("Liufriends/friends", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: [PartnerModel].self).subscribe(onNext: { (model) in
            if let data = model.data {
                if data.count > 1 {
                    let arr = data.map({ (model) -> DDUserModel in
                        let userModel = DDUserModel.init()
                        userModel.head_images = model.blogo
                        userModel.unitPrice = model.bPrice
                        userModel.id = model.bid ?? "0"
                        userModel.phone = model.bphone
                        userModel.nickname = model.bname
                        
                        return userModel
                    })
                    finished(arr)
                }else {
                    let arr = data.map({ (model) -> DDUserModel in
                        let userModel = DDUserModel.init()
                        userModel.head_images = model.blogo
                        userModel.unitPrice = model.bPrice
                        userModel.id = model.bid ?? "0"
                        userModel.nickname = model.bname
                        return userModel
                    })
                    finished(arr)
                }
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    
    
}
class PartnerModel: Codable {
    
    /// 用户ID
    var bid: String?
    /// 用户名
    var bname: String?
    ///用户头像
    var blogo: String?
    ///用户电话
    var bphone: String?
    var bPrice: String?;
}


