//
//  Payfile.swift
//  Project
//
//  Created by wy on 2018/1/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
import UIKit
enum PayMentType {
    
    ///支付宝约定下单
    case Alipay
    ///微信支付约定下单
    case WeiChatpay
    ///银联支付约定下单
    case UnionPay
    ///线下支付约定下单
    case under
    ///支付宝充值
    case AlipayRecharge
    ///微信充值
    case WeiXinRecharge
    ///余额付款(约定下单)
    case balancePay
    ///约定线下付款
    case AppointmentUnderPay
    ///充值线下付款。
    case UnderPayReacharge
    ///直接付款
    case DirectPay
    ///微信直接付款
    case DirectPayWithWeiChat
    ///直接付款用支付宝
    case DirectPaytWithAlipay
    ///直接付款余额
    case DirectPayWithBlance
    ///提现
    case WithDraw
    ///放款
    case Loan
    
    
    
    
}
///支付宝支付结果
struct PayResult {
    var result: Bool = false
    var failurereason: String = "支付失败"
    var paramete: AnyObject?
}

final class PayManager: NSObject, WXApiDelegate{
    static let share = PayManager.init()
    private override init(){
        super.init()
    }

    
    /// 支付方法
    ///
    /// - Parameters:
    ///   - paremete: 参数.余额支付的时候传入字典 ["order_code": "0", "payword": "333"]
    ///   - payMentType: 支付方式
    ///   - success: 成功的回调
    ///   - failure: 失败的回调
    func pay(paremete: AnyObject, payMentType: PayMentType, finished: ((PayMentType, PayResult) -> ())?) {
        switch payMentType {
        
        case .Alipay:
            self.performAliPayWithParamete(paramete: paremete, type: payMentType, finished: finished)

        case .WeiChatpay:
            self.performWeiChatPayWithParamete(paramete: paremete, type: payMentType, finished: finished)
        case .UnionPay:
            self.performUnionPayWithParamete(paramete: paremete)
        case .under:
            self.performUnderPayWithParamete(paramete: paremete, type: payMentType, finished: finished)
        case .UnderPayReacharge:
            self.performUnderPayWithParamete(paramete: paremete, type: payMentType, finished: finished)
        case .AlipayRecharge:
            self.performAliPayWithParamete(paramete: paremete, type: payMentType, finished: finished)
        case .WeiXinRecharge:
            self.performWeiChatPayWithParamete(paramete: paremete, type: payMentType, finished: finished)
        case .balancePay:
            self.performBalancePayWithParamete(paramete: paremete, type: payMentType, finished: finished)
        case .DirectPay:
            self.performDirectPayWithParamete(paramete: paremete, finished: finished)
            
        default:
            break
        }
    }
    var alipayFinished: ((PayMentType, PayResult) -> ())?
    ///服务器加密


    ///银联支付
    func performUnionPayWithParamete(paramete: AnyObject) {
        
    }
    ///线下支付
    private func performUnderPayWithParamete(paramete: AnyObject, type: PayMentType, finished: ((PayMentType, PayResult) -> ())?) {
        var url: String = ""
        var parametes: [String: String] = [String: String]()
        switch type {
        case .under:
            guard let value = paramete as? String else {
                GDAlertView.alert("请求参数不对", image: nil, time: 2, complateBlock: nil)
                return
            }
            url = "Linepayment/rest"
            parametes = ["order_code": value]
        case .UnderPayReacharge:
            guard let value = paramete as? String else {
                GDAlertView.alert("请求参数不对", image: nil, time: 2, complateBlock: nil)
                return
            }
            url = "Linecharge/rest"
            parametes = ["price": value, "type": "0"]
        
        default:
            break
        }
        var result = PayResult.init()
        let router = Router.post(url, .api, parametes, nil)
        NetWork.manager.requestData(router: router, type: UnderPayModel.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                result.result = true
                result.paramete = model.data
                
            }else {
                result.result = false
                result.failurereason = model.message ?? ""
            }
            if finished != nil {
                finished!(type, result)
            }
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    
   
  
    ///微信支付返回的结果

    var weixinResult: ((PayMentType ,PayResult) -> ())?
    func onResp(_ resp: BaseResp!) {
        var result = PayResult.init()
        let code = resp.errCode
        switch code {
        case WXSuccess.rawValue:
            result.result = true
            
            self.weixinResult!(PayMentType.WeiChatpay, result)
        case WXErrCodeCommon.rawValue:
            result.result = false
            result.failurereason = "支付失败请重新支付"
            self.weixinResult!(PayMentType.WeiChatpay, result)
            mylog("错误    可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。")
        case WXErrCodeUserCancel.rawValue:
            result.failurereason = "用户取消"
            self.weixinResult!(PayMentType.WeiChatpay, result)
            mylog("用户取消    无需处理。发生场景：用户不支付了，点击取消，返回APP")
        case WXErrCodeSentFail.rawValue:
            result.failurereason = "请检查网络，重新支付"
            self.weixinResult!(PayMentType.WeiChatpay, result)
            mylog("发送失败 ")
        case WXErrCodeAuthDeny.rawValue:
            result.failurereason = "支付失败请重新支付"
            self.weixinResult!(PayMentType.WeiChatpay, result)
            mylog("")
        case WXErrCodeUnsupport.rawValue:
            result.failurereason = "微信不支持"
            self.weixinResult!(PayMentType.WeiChatpay, result)
        default:
            break
        }
    }
    
}
extension PayManager {
    
    private func performWeiChatPayWithParamete(paramete: AnyObject, type: PayMentType, finished: ((PayMentType, PayResult) -> ())?) {
        self.weixinResult = finished
        var result = PayResult.init()
        //判断是否安装微信客户端
        class SignModel: Codable {
            var token: String?
            var appId: String?
            var mch_id: String?
            var nonceStr: String?
            var sign: String?
            var result_code: String?
            var prepayId: String?
            var trade_type: String?
            var partnerId: String?
            var timeStamp: Int?
            var package: String?
            
        }
        
        var url: String = ""
        var parametes: [String: AnyObject] = [String: AnyObject]()
        switch type {
        case .WeiChatpay:
            guard let value = paramete as? String else {
                GDAlertView.alert("请求参数不对", image: nil, time: 2, complateBlock: nil)
                return
            }
            url = "Wxrecharge/rest"
            parametes = ["order_code": value, "type": "0"] as [String : AnyObject]
        case .WeiXinRecharge:
            guard let value = paramete as? String else {
                GDAlertView.alert("请求参数不对", image: nil, time: 2, complateBlock: nil)
                return
            }
            url = "Wxrecharge2/rest"
            parametes = ["price": value, "type": "0"] as [String : AnyObject]
        case .DirectPayWithWeiChat:
            guard let value = paramete as? [String: AnyObject] else {
                GDAlertView.alert("请求参数不对", image: nil, time: 2, complateBlock: nil)
                return
            }
            url = "Transfermoney/rest"
            parametes = value as [String : AnyObject]
        default:
            break
        }
        let router = Router.post(url, .api, parametes, nil)
        NetWork.manager.requestData(router: router, type: SignModel.self).subscribe(onNext: { (model) in
            if let signModel = model.data {
                guard let partnerId = signModel.partnerId else {
                    return
                }
                guard let prepayid = signModel.prepayId else {
                    return
                }
                guard let nonce = signModel.nonceStr else {
                    return
                }
                guard let sign = signModel.sign else {
                    return
                }
                
                guard let timeStamp = signModel.timeStamp else {
                    return
                }
                
                
                if WXApi.isWXAppInstalled() {
                    //获取微信支付需要的信息
                    let req = PayReq.init()
                    req.partnerId = partnerId
                    req.prepayId = prepayid
                    req.nonceStr = nonce
                    req.timeStamp = UInt32(timeStamp)
                    req.package = "Sign=WXPay"
                    req.sign = sign
                    WXApi.send(req)
                }else {
                    result.failurereason = "您的手机没有安装微信"
                    finished?(PayMentType.WeiChatpay, result)
                }
            }else {
                result.failurereason = model.message
                finished?(PayMentType.WeiChatpay, result)
            }
        }, onError: { (error) in
            result.failurereason = "请检查网络"
            finished?(PayMentType.WeiChatpay, result)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
   
    ///支付宝约定下单
    
    private func performAliPayWithParamete(paramete: AnyObject,type: PayMentType, finished: ((PayMentType, PayResult) -> ())?) {
        self.alipayFinished = finished
        var parametes: [String: String] = [String: String]()
        var url: String = ""
        switch type {
        case .Alipay:
            guard let value  = paramete as? String else {
                GDAlertView.alert("参数不对", image: nil, time: 1, complateBlock: nil)
                return
            }
            parametes = ["order_code": value, "type": "0"]
            url = "Rsarecharge/rest"
        case .AlipayRecharge:
            guard let value  = paramete as? String else {
                GDAlertView.alert("参数不对", image: nil, time: 1, complateBlock: nil)
                return
            }
            parametes = ["price": value, "type": "0"]
            url = "Rsarecharge2/rest"
        case .DirectPaytWithAlipay:
            guard let value = paramete as? [String: String] else {
                GDAlertView.alert("请求参数不对", image: nil, time: 2, complateBlock: nil)
                return
            }
            url = "Transfermoney/rest"
            parametes = value
        default:
            break
        }
        var result = PayResult.init()
        let router = Router.post(url, .api, parametes, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                if let sign = model.data {
                    let appScheme = "com.16lao.18t80"
                    
                    AlipaySDK.defaultService().payOrder(sign, fromScheme: appScheme) { (resultDict) in
//                        mylog(resultDict)
//                        guard let resultStatus = resultDict?["resultStatus"] as? String else {
//                            finished?(type, result)
//                            return
//                        }
//
//
//                        if resultStatus == "9000" {
//                            result.result = true
//                        }else {
//
//                            result.result = false
//                        }
//                        if finished != nil {
//                            finished!(type, result)
//                        }
                        ///支付宝成功的回调
                        
                    }
                    
                }
            }else {
                result.failurereason = model.message
                if finished != nil {
                    finished!(type, result)
                }
            }
            
        }, onError: { (error) in
            result.result = false
            result.failurereason = "网络连接失败"
            if finished != nil {
                finished!(type, result)
            }
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    private func performBalancePayWithParamete(paramete: AnyObject, type: PayMentType, finished: ((PayMentType, PayResult) -> ())?) {
        var url: String = ""
        var parametes: [String: String] = [String: String]()
        switch type {
        case .DirectPayWithBlance:
            guard let value = paramete as? [String: String] else {
                GDAlertView.alert("请求参数不对", image: nil, time: 2, complateBlock: nil)
                return
            }
            url = "Transfermoney/rest"
            parametes = value
        case .balancePay:
            guard var dict  = paramete as? [String: String] else {
                GDAlertView.alert("参数不对", image: nil, time: 1, complateBlock: nil)
                return
            }

            url = "Balancepayment/rest"
            dict["type"] = "0"
            parametes = dict
        default:
            break
        }
        
        
        var result = PayResult.init()
        let router = Router.post(url, .api, parametes, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                if finished != nil {
                    result.result = true
                    result.failurereason = model.message
                    finished!(PayMentType.balancePay, result)
                }
            }else {
                if finished != nil {
                    result.result = false
                    result.failurereason = model.message
                    finished!(PayMentType.balancePay, result)
                }
                
            }
        }, onError: { (error) in
            if finished != nil {
                finished!(PayMentType.balancePay, result)
            }
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    
    private func performDirectPayWithParamete(paramete: AnyObject, finished: ((PayMentType, PayResult) -> ())?) {
        guard let dict = paramete as? [String: String], let type = dict["type"] else {
            return
        }
        if type == "0" {
            self.performBalancePayWithParamete(paramete: paramete, type: .DirectPayWithBlance, finished: finished)
           
        }
        if type == "4" {
            self.performAliPayWithParamete(paramete: paramete, type: .DirectPaytWithAlipay, finished: finished)
        }
        if type == "5" {
            self.performWeiChatPayWithParamete(paramete: paramete, type: .DirectPayWithWeiChat, finished: finished)
        }
        
        
        
        
    }
    
    
    
}
class UnderPayModel: Codable {
    var ls: String?
    var price: Int?
    var name: String?
    var address: String?
    var card_number: String?
    var card_name: String?
}


