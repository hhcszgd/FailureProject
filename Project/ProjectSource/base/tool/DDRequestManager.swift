//
//  DDRequestManager.swift
//  hhcszgd
//
//  Created by WY on 2018/1/17.
//  Copyright © 2018年 com.16lao. All rights reserved.
import UIKit
import Alamofire
import CoreLocation
import CryptoSwift
class DDRequestManager: NSObject {
    let client = COSClient.init(appId: "1252043302", withRegion: "tj")
    var sessionManager : SessionManager!
    //    let hostSurfix  = "cc"
    enum DomainType : String  {
        case release  = "http://18t80.1818lao.com/"
        case wap = "http://tap.bjyltf.com/" //tap.bjyltf.com，"http://wap.bjyltf.cc/"
    }
    
    var networkStatus : (oldStatus : Bool , newStatus : Bool ) =  (oldStatus : true , newStatus : true )
    
    lazy var networkReachabilityManager: NetworkReachabilityManager? = {
        let reachabilityManager = NetworkReachabilityManager.init(host: "www.baidu.com")//必须写域名
//        let reachabilityManager = NetworkReachabilityManager()//错 , 不准

        reachabilityManager?.listener = {status in
            self.networkStatus.oldStatus = self.networkStatus.newStatus
            
//            reachabilityManager?.startListening()
            switch status {
            case .notReachable:
                mylog("1")
//                GDAlertView.alert("网络连接失败", image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .unknown :
                mylog("2")
//                GDAlertView.alert("网络连接失败", image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                mylog("3")
                self.networkStatus.newStatus = true
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                self.networkStatus.newStatus = true
                mylog("4")
                break
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                DDNotification.postNetworkChanged(networkStatus: self.networkStatus)
            })
            
        }
        let result = reachabilityManager?.startListening()
        mylog("监听网络是否成功 : \(result)")
        return reachabilityManager
    }()

    
    ///
    func saveJpushID<T>(type : ApiModel<T>.Type ,registrationID:String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Push/rest"
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : ["registrationID":registrationID]  , complate: complate)
    }
    
    ///判断是否设置支付密码
    /// name    手机号    string
    /// status    状态(1:已设置，0:未设置)    int
    func whetherSetPayPassword<T>(type : ApiModel<T>.Type , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Mttuserinfo/getPayname"
        self.prepareForRequest(type: type , method: HTTPMethod.get, url: url ,parameters : nil  , complate: complate)
    }
    
    
    ///删除首页消息
    func deleteHomeMessage<T>(type : ApiModel<T>.Type ,mid : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weideletemessage/rest"
        let para = [ "mid": mid]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    ///查看单价详情
    
    func seeUnitPriceDetail<T>(type : ApiModel<T>.Type ,order_id : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weigetperiodslist/showPriceList"
        let para = [ "orderid": order_id]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    
    ///约定中 更多伙伴列表
    func morePartnersInAppointDetail<T>(type : ApiModel<T>.Type ,order_id : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liufriends/bnamelist"
        let para = [ "order_id": order_id]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    
    
    ///一键放款【批量放款】(含单人和多人)
    func payToPartner<T>(type : ApiModel<T>.Type ,partnerIDs : [String] ,payword:String, complate : @escaping ((ApiModel<T>?)->())){
        guard let partnerIDsJsonFormte = DDJsonCode.encode(partnerIDs) else {
            complate(nil)
            return
        }
        let url =  "Onekeypayoff/rest"
        let para = [ "fid" : partnerIDsJsonFormte , "payword" : payword]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    
    func addToPublicAppoint<T>(type : ApiModel<T>.Type,orderid:String , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liuopenjoin/join"
        let para = ["order_id":orderid ]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    
    func addToPrivateAppoint<T>(type : ApiModel<T>.Type,orderid:String , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Addappointment/rest"
        let para = ["order_id":orderid ]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    
    
    ///开工
    func startAppoint<T>(type : ApiModel<T>.Type,orderid:String , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Openappointment/rest"
        let para = ["order_code":orderid ]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    
    
    
    ///约定下单付款 , 通过余额
    func payOrderWithLaoPay<T>(type : ApiModel<T>.Type,orderid:String , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Balancepayment/rest"
        var para = ["order_code":orderid , "type":"0" , "payword": "123456"]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    
    
    
    
    ///获取约定中的成员
    func getPartnerListOfAppoint<T>(type : ApiModel<T>.Type,orderid:String,keywords : String? = nil , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weiconventbid/rest"
        var para = ["orderid":orderid]
        if let keywordWnwrap = keywords{para["keywords"] = keywordWnwrap}
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para  , complate: complate)
    }
    
    ///获取银行卡列表
    func getBankCards<T>(type : ApiModel<T>.Type, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Mttuserinfo/getBankcard"
        self.prepareForRequest(type: type , method: HTTPMethod.get, url: url ,parameters : nil  , complate: complate)
    }
    
    
    ///公开约定详情
    func publicAppointDetail<T>(type : ApiModel<T>.Type,order_id:String,user_type:String,bid : String? = nil , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liuopeninfo/Details"
        var para = ["order_id":order_id,"user_type":user_type]
        if let bid = bid {
            para["bid"] = bid
        }
        mylog(para)
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para , complate: complate)
    }
    
    ///非公开约定详情
    /// -order_id:约定id   user_type:用户属性(1/2)(收款方/付款方)   bid:乙方id
    func privateAppointDetail<T>(type : ApiModel<T>.Type,order_id:String,user_type:String,bid:String? = nil , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liuinfoone/details_one"
        var para = ["order_id":order_id,"user_type":user_type]
        if let yiID = bid , yiID.count > 0 { para["bid"] = yiID}
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para , complate: complate)
    }
    
    ///(1:发起的约定列表;2:接收的约定列表)
    func appointList<T>(type : ApiModel<T>.Type,appointType:String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liutest/ylist"
        let para = ["type":appointType]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para , complate: complate)
    }
    
    
    func setRealName<T>(type : ApiModel<T>.Type,name:String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Mttupdateinfo/updatename"
        let para = ["nickname":name]
        self.prepareForRequest(type: type , method: HTTPMethod.put, url: url ,parameters : para , complate: complate)
    }
    
    func createSmartAppoint<T>(type : ApiModel<T>.Type,full_name:String?,price_one:String ,price  : String, Lenders : String,payment_time: String,friends_id: String, types: String ,num: String , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liutest/Singlezn"
        var para : [String:String]?
        
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para , complate: complate)
    }
    
    
    func createSingleAppoint<T>(type : ApiModel<T>.Type,full_name:String? ,price  : String, Lenders : String,payment_time: String,friends_id: String, types: String , complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liutest/Singleone"
        var para : [String:String]?

        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para , complate: complate)
    }
    
    func choosePartnerAndAppoint<T>(type : ApiModel<T>.Type,keyWord:String? ,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weimakegroup/rest"
        var para : [String:String]?
        if let key = keyWord{
            para = ["keywords":key]
        }
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url ,parameters : para , complate: complate)
    }
    
    
    
    func performGetCash<T>(type : ApiModel<T>.Type,para:(name:String,card_number:String,price:String,payPassword:String , code: String?) ,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Takeout/rest"
        var paras = ["name":para.name,"card_number":para.card_number,"price":para.price,"payword":para.payPassword]
        if let code = para.code{
            paras["code"] = code
        }
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url,parameters: paras , complate: complate)
    }
    
    func getCashPageApi<T>(type : ApiModel<T>.Type ,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Mttuserinfo/getWithdrawal"
        self.prepareForRequest(type: type , method: HTTPMethod.get, url: url , complate: complate)
    }
    
    
    func whetherAgreeBeAddFriend<T>(type : ApiModel<T>.Type ,whetherAgree:Bool,userID : String,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weiagreeapply/rest"
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: ["other":userID , "type" : whetherAgree ? "1" : "2" ], complate: complate)
    }
    
    func addFriend<T>(type : ApiModel<T>.Type ,userID : String,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weiapplyfd/rest"
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: ["other":userID], complate: complate)
    }
    /// 智能搜索(范围是所有人,付款/收款/公开 约定)
    ///
    /// - Parameters:
    ///   - type: 数据类型
    ///   - keywords: 关键词:伙伴姓名/约定名称/要求/金额/地址/付款人
    ///   - search_type: 搜索类型1:全部、2:我发布的【付款方】、3:我参与的【收款方】、4:公开约定
    ///   - page: 页码
    ///   - complate: 回调
    func searchSmartly<T>(type : ApiModel<T>.Type ,keywords: String , search_type : String = "1" , page:String = "0",complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weiintelligentsearch/rest"
        let para = ["keywords":keywords , "search_type":search_type , "page":page]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para , complate: complate)
    }
    
    ///搜用户(范围是所有人)
    func searchUser<T>(type : ApiModel<T>.Type ,username: String,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weiusersearch/rest"
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: ["username":username], complate: complate)
    }
    
    ///搜好友(范围是好友)
    ///
    /// -username 好友姓名和账号手机号
    func searchPartner<T>(type : ApiModel<T>.Type ,username: String,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weifriendsearch/rest"
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: ["username":username], complate: complate)
    }
    
    
    func homeMessageDetailApi<T>(type : ApiModel<T>.Type ,messageID: String , page : String = "0" ,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weishowmessage/rest"
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: ["mid":messageID , "page":page ], complate: complate)
    }
    

    func homeApi<T>(type : ApiModel<T>.Type ,page: String,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weisystemessage/rest"
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: ["page":page], complate: complate)
    }
    
//    func getPartnerAndApointList<T>(type : ApiModel<T>.Type ,keyword:String?,complate : @escaping ((ApiModel<T>?)->())){
//        let url =  "Weimakegroup/rest"
//        var para : [String : String]?
//        if let key = keyword{
//            para = ["keywords": key]
//        }
//        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url, complate: complate)
//    }

    func getPartnerList<T>(type : ApiModel<T>.Type ,complate : @escaping ((ApiModel<T>?)->())){
        let url = "Weifriendslist/rest"
        self.prepareForRequest(type: type , method: HTTPMethod.get , url: url, complate: complate)
    }
    
    func getPartnerInfo<T>(type : ApiModel<T>.Type , userID:String,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weiusershow/rest"
        self.prepareForRequest(type: type,method: HTTPMethod.post, url: url , parameters: ["uid":userID] , complate: complate)
    }
    
    ///codeType : 注册:1,找回密码:2,绑定银行卡3,设置支付密码:4,其它:0
    func sentCode<T>(type : ApiModel<T>.Type ,mobile:String , codeType: String = "0",complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Getverificationcode/rest"
        let para =  [ "type" : codeType , "mobile" : mobile]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    
    ///验证验证码
    func checkAuthCode<T>(type : ApiModel<T>.Type ,mobile:String , code: String,complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Vercode/rest"
        let para =  [ "mobilecode" : code , "mobile" : mobile]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    
    

    /*
     获取公开约定列表
     sort    筛选条件   1:最新,2:随时开始,3:人满开始
     range    地区
     page    当前页数
     */
    func getOpenAppiontList<T>(type : ApiModel<T>.Type ,sort:String , range: String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liuopen/openlist"
        let para =  [ "sort" : sort , "range" : range, "page" : "1", "keywords": "", ]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    /*
     获取广告列表
     id    广告id
     */
    func getAdvertisementRest<T>(type : ApiModel<T>.Type ,id: String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Advertisement/rest"
        let para =  [ "id" : id]
//        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
        self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para , success: complate, failure: {(error) in}, complate: {})
    }
    
    /*
     提交公开约定
     full_name    约定名称
     price_one    元/人
     person_num    人数
     Lenders     放款方式
     num_time    有效期时间
     price    总金额
     num    数量（期）
     a_start    何时开始
     range    区域
     requirement    要求
     */
    func postPublicAppoint<T>(type : ApiModel<T>.Type, full_name: String, price_one: String, person_num: String, Lenders: String, num_time: String, price: String, num: String, a_start: String, range: String, requirement: String, address_id : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liuopen/group"
        let para =  [ "full_name" : full_name, "price_one" : price_one, "person_num" : person_num, "Lenders" : Lenders, "num_time" : num_time, "price" : price, "num" : num, "a_start" : a_start, "range" : range, "requirement" : requirement, "address_id" : address_id]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    /*
     获取区域列表
     */
    func getRegionAddress<T>(type : ApiModel<T>.Type , parentid: Dictionary<String, Any>?, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liuopen/address"
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: parentid, complate: complate)
    }
    
    /*
     获取放款人列表
     order_id  约定id
     num  期数 可选填 单期约定可为空
     */
    func getLendersList<T>(type : ApiModel<T>.Type , order_id: String , num: String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Lenderslist/rest"
        let para =  ["order_id" : order_id , "num" : num]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 获取终止约定原定金额
    func getOriginalMonay<T>(type : ApiModel<T>.Type ,appointment_id: String , aid: String, bid: String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Termappointment/rest"
        let para =  [ "appointment_id" : appointment_id , "aid" : aid, "bid" : bid]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 获取单人约定放款期数
    func getEarnerStageSingle<T>(type : ApiModel<T>.Type ,order_id:String, bid: String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Onenumlist/rest"
        let para =  [ "order_id" : order_id, "bid" : bid]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 获取多人约定放款期数
    func getEarnerStageMore<T>(type : ApiModel<T>.Type ,order_id:String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Numlist/rest"
        let para =  [ "order_id" : order_id]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 提交终止约定
    func postEndAppointInfo<T>(type : ApiModel<T>.Type , aid : String, bid : String, Oriamount : String, Payamount : String, Retamount : String, Reason : String, vid : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Appointmentdetsubmit/rest"
        let para =  ["aid" : aid, "bid" : bid, "Oriamount" : Oriamount, "Payamount" : Payamount, "Retamount" : Retamount, "Reason" : Reason, "vid" : vid]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 获取修改金额
    func getChangeMoney<T>(type : ApiModel<T>.Type , orderid : String, bid : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weigetperiodslist/rest"
        let para =  ["orderid" : orderid, "bid" : bid]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 获取修改金额详情
    func getChangeMoneyDetail<T>(type : ApiModel<T>.Type , orderid : String, fid : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weishowperiodsinfo/rest"
        let para =  ["orderid" : orderid, "fid" : fid]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 提交修改金额
    func postChangeMoney<T>(type : ApiModel<T>.Type , fid : String, bid : String, orderid : String, money : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weimodifymoney/rest"
        let para =  ["fid" : fid, "bid" : bid, "orderid" : orderid, "money" : money]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 收款方拒绝金额修改
    func refuseMoneyChange<T>(type : ApiModel<T>.Type ,orderid: String, rid : String, pay_price : String, rest_price : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weibidrefuse/rest"
        let para =  ["orderid" : orderid , "rid" : rid, "pay_price" : pay_price, "rest_price" : rest_price]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 收款方接受金额修改
    func acceptMoneyChange<T>(type : ApiModel<T>.Type ,orderid: String, rid : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weibidagree/rest"
        let para =  ["orderid" : orderid , "rid" : rid]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 付款方接受收款方金额修改
    func acceptSecondMoneyChange<T>(type : ApiModel<T>.Type ,orderid: String, rid : String, payword: String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weiaidagreebid/rest"
        let para =  ["orderid" : orderid , "rid" : rid, "payword": payword]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 约定放款详情
    func getPayPartnersDetail<T>(type : ApiModel<T>.Type ,order_id: String, num : String, lenders: String, bid : String, yue_type: String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Liufkinfo/flist"
        let para =  ["order_id" : order_id , "num" : num, "lenders": lenders, "bid" : bid, "yue_type": yue_type]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
    
    // 甲方同意乙方拒绝约定修改自动放款的校验时效性接口
    func checkAutoInvalid<T>(type : ApiModel<T>.Type ,orderid: String, rid : String, complate : @escaping ((ApiModel<T>?)->())){
        let url =  "Weiaidagreebid/checkAutoInvalid"
        let para =  ["orderid" : orderid , "rid" : rid]
        self.prepareForRequest(type: type , method: HTTPMethod.post, url: url , parameters: para, complate: complate)
    }
}

















// MARK: - base method
extension DDRequestManager{

    var DDToken : String? {
        if token != "nil" && token.count > 0 {
            return token
        }else{
            if let tokentoken =  DDStorgeManager.share.value(forKey: "DDToken") as? String{
                return tokentoken
            }else{
                mylog("there no token , recreate it")
                self.createToken(type: (ApiModel<String>.self ))
                return nil
            }
        }
    }
    // MARK: 注释 : share
    static let share : DDRequestManager = {
        let man = DDRequestManager()
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval.init(10)
//        sessionConfig.timeoutIntervalForResource = TimeInterval.init(10)
//        let urlSession = URLSession.init(configuration: sessionConfig)
        let sessionDelegate = SessionDelegate()
        let urlSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
        man.sessionManager = SessionManager.init(session: urlSession, delegate: sessionDelegate)
        mylog(man.sessionManager)
        let time = man.sessionManager.session.configuration.timeoutIntervalForRequest
        mylog(time )
        mylog(man.sessionManager.session.configuration.timeoutIntervalForRequest )
        return man
    }()
    
    private func performRequest(url : String,method:HTTPMethod , parameters: Parameters? ,  print : Bool = false  ) -> DataRequest? {
        

        var para = Parameters()
        if let parametersUnwrap = parameters{para = parametersUnwrap}
        para["l"] = DDLanguageManager.languageIdentifier
//        para["c"] = DDLanguageManager.countryCode
        para["c"] = "110"
                if url != DomainType.release.rawValue + "Initkey/rest"{//初始化接口不需要token
                    if let tokenReal = DDToken {
                        para["token"] = tokenReal
                    }else{
                        mylog("token is nil")
                        return nil
                    }
                }
        
        
//        let language = DDLanguageManager.countryCode
        let language = "110"
        var header = [String : String]()
        header["APPID"] = "2"
        header["VERSIONMINI"] = "20160501"
        header["DID"] = ZDID
        header["VERSIONID"] = "2.0"
        header["language"] = language
        
        
//        para["token"] = "58a2d7314d3080ba80d6ed775331b9fa"
//        let language = DDLanguageManager.countryCode
//        var header = [String : String]()
//        header["APPID"] = "1"
//        header["VERSIONMINI"] = "20160501"
//        header["DID"] = "123"//ZDID
//        header["VERSIONID"] = "2.0"
//        header["language"] = language
//        if let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//            header["VERSIONID"] = currentAppVersion
//        }
        //        let url = replaceHostSurfix(urlStr: url, surfix: hostSurfix)
        if let url  = URL(string: url){
            let result = DDRequestManager.share.sessionManager.request(url , method: method , parameters: para , headers:header).responseJSON(completionHandler: { (response) in
                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    mylog(DDRequestManager.share.sessionManager.session.configuration.timeoutIntervalForRequest)
                    break
                case .failure :
                    //                    GDAlertView.alert("error", image: nil , time: 2, complateBlock: nil )//请求超时处理
                    mylog(response.debugDescription.unicodeStr)
                    mylog("❗️❗️服务器返回数据位置 请求参数为:\(url)|\(parameters)")
                }
            })
            return result
        }else{return nil }
    }
    private func prepareForRequest<T>(type : ApiModel<T>.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil ,needPrint:Bool = false,complate : @escaping ((ApiModel<T>?)->())) {
        
        if let status = networkReachabilityManager?.isReachable , !status {
//            GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
            complate(nil)
            return
//            switch status {
//            case .notReachable:
//                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
//                complate(nil)
//                return
//            case .unknown :
//                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
//                complate(nil)
//                return
//            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
//                break
//            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
//                break
//            }
        }
        
        
        
        
        let urlFull = DomainType.release.rawValue + url
        if let task = self.performRequest(url: urlFull , method: method, parameters: parameters  , print: needPrint ){
            task.responseJSON(completionHandler: { (response ) in
                
                if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
                    if a.status != 200{mylog("❗️❗️非期望数据: 请求参数为:\(url)|\(parameters)")}
                    complate(a)
                }else{
                    complate(nil)
                    //                mylog("转换模型失败:\(response.debugDescription)")
                }
            })
        }else{
            complate(nil)
        }
//        self.performRequest(url: urlFull , method: method, parameters: parameters  , print: needPrint )?.responseJSON(completionHandler: { (response ) in
//
//            if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
//                if a.status != 200{mylog("❗️❗️非期望数据: 请求参数为:\(url)|\(parameters)")}
//                complate(a)
//            }else{
//                complate(nil)
////                mylog("转换模型失败:\(response.debugDescription)")
//            }
//        })
    }
    ///例外
    func createToken<T>(type : (ApiModel<T>.Type),complate : ((ApiModel<T>?)->())? = nil ){
        let url = DomainType.release.rawValue + "Initkey/rest"
        self.performRequest(url: url , method: HTTPMethod.get, parameters: nil , print: false )?.responseJSON(completionHandler: { (response ) in
            if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
                complate?(a)
                if let result =  a as? ApiModel<String> , let key = result.data{
                    let token =  ( ZDID + key ).md5()
                    DDStorgeManager.share.setValue(token, forKey: "DDToken")
                }
            }else{
                complate?(nil)
                mylog(response.debugDescription)
            }
            
        })
    }
    

}


// MARK: - -----------------------------最低捞-----------------------------------
extension DDRequestManager{
    
    private  func replaceHostSurfix( urlStr : String , surfix : String = "cn") -> String {
        //        var urlStr = "http://www.baidu.com/fould/index.html?name=name"
        var urlStr  = urlStr
        if let url = URL(string: urlStr) {
            var host = url.host ?? ""
            let http = url.scheme ?? "" //http or https
            let index = host.index(host.endIndex, offsetBy: -3)
            let willReplaceStr = "\(http)://\(host)"
            let willReplaceRange = willReplaceStr.startIndex..<willReplaceStr.endIndex
            host.removeSubrange(index..<host.endIndex)
            if !host.hasSuffix("."){host = "\(host)."}
            host.append(contentsOf: surfix)
            let destinationStr  = "\(http)://\(host)"
            urlStr.replaceSubrange(willReplaceRange, with: destinationStr)
            mylog("converted:\(urlStr)")
        }
        return urlStr
    }
    /// 获取周边商家
    ///
    /// - 接口api:http://api.hilao.cc/index/nearbyShop
    /// - requestMetho : POST
    @discardableResult
    func homepageNearbyShops(page:Int ,coordinate:CLLocationCoordinate2D? = nil,_ print : Bool = false ) -> DataRequest? {
        var longtitude : String = ""
        var latitude : String = ""
        let location = DDLocationManager.share.locationManager.location
        longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude) ?? 0])
        latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude) ?? 0])
        if let unWrapCoordinate = coordinate {
            longtitude = "\(unWrapCoordinate.longitude)"
            latitude = "\(unWrapCoordinate.latitude)"
        }
        let url  =  "http://api.hilao.cc/index/nearbyShop"
        let para = ["lon" : longtitude , "lat" : latitude , "p" : "\(page)"]
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    ///  搜索主页
    ///
    /// http://api.hilao.cc/index/searchIndex
    ///POST
    @discardableResult
    func hotSearch(_ print : Bool = false ) -> DataRequest? {
        let url  =  "http://api.hilao.cc/Search/searchIndex"
        let para = ["token" : token] as [String : Any]
        //        let para = [ "member_id" : 95  , "token" : "101faa72fd8cd4f1cdb5ef3ca6e8d49c29cd36e9"] as [String : Any]
        
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    ///   搜索（*结果数据有待确定）
    ///
    ///接口地址： http://api.hilao.cc/index/search
    ///请求方式：POST
    @discardableResult
    func performSearchShop(keyword : String , _ print : Bool = false ) -> DataRequest? {
        let location = DDLocationManager.share.locationManager.location
        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude) ?? 0])
        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude) ?? 0])
        let url  =  "http://api.hilao.cc/search/search"
        var  para = [ "lon" : longtitude , "lat" : latitude ,  "keyword":keyword  , "token" : token]
        
        
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    /// 店铺详情
    
    @discardableResult
    func shopDetail(shopID : String , _ print : Bool = false ) -> DataRequest? {
        let location = DDLocationManager.share.locationManager.location
        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude) ?? 0])
        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude) ?? 0])
        let url  =  "http://shop.hilao.cc/shop/shopinfo"
        var  para = [ "lon" : longtitude , "lat" : latitude ,  "shop_id":shopID  , "token" : token]
       
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    /// 互动
    @discardableResult
    func huDong(page : Int , _ print : Bool = false ) -> DataRequest? {
        let location = DDLocationManager.share.locationManager.location
        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude) ?? 0])
        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude) ?? 0])
        let url  =  "http://interactive.hilao.cc/Index/interactive"
        let  para = [ "lng" : longtitude , "lat" : latitude ,  "page":"\(page)"  ]
        return performRequest(url: url , method: HTTPMethod.get, parameters: para, print : print )
    }
    /// 评论详情页分两个接口
    /// 第一个是:评论本身
    ///    http://comment.hilao.dev/comment/commentinfo
    @discardableResult
    func commentDetail(commentID : String , _ print : Bool = false ) -> DataRequest? {
        let location = DDLocationManager.share.locationManager.location
        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude) ?? 0])
        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude) ?? 0])
        let url  =  "http://comment.hilao.cc/comment/commentinfo"
        let  para = [ "lng" : longtitude , "lat" : latitude ,  "comment_id": commentID  ]
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    /// 第二个是:给这条评论的回复列表
    ///    http://comment.hilao.dev/comment/commentinfo
    @discardableResult
    func commentReplyList(commentID : String , _ print : Bool = false ) -> DataRequest? {
        let location = DDLocationManager.share.locationManager.location
        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude) ?? 0])
        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude) ?? 0])
        let url  =  "http://comment.hilao.cc/comment/commentreplylist"
        let  para = [ "lng" : longtitude , "lat" : latitude ,  "comment_id": commentID  ]
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    /// 获取评论标签
    /// url http://shop.hilao.dev/ShopClassify
    @discardableResult
    func getCommentLabels(classify_pid : String , _ print : Bool = false ) -> DataRequest? {
        //        let location = DDLocationManager.share.locationManager.location
        //        let longtitude = String.init(format: "%.08f", arguments: [(location?.coordinate.longitude) ?? 0])
        //        let latitude = String.init(format: "%.08f", arguments: [(location?.coordinate.latitude) ?? 0])
        let url  =  "http://shop.hilao.cc/ShopClassify"
        let  para = [ "classify_pid": classify_pid  ]
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    
    /// 写评论
    /// url http://comment.hilao.dev/comment
    /// requestMethod : post
    @discardableResult
    func writeComment(parametes : (shop_id:String,shop_name:String , content:String,is_img:Int ,images:String?,type:Int , score:Int) , _ print : Bool = false ) -> DataRequest? {
        let url  =  "http://comment.hilao.cc/comment"
        var  para = [
            "shop_id": parametes.shop_id,
            "shop_name":parametes.shop_name ,
            "content":parametes.content,
            "is_img" :parametes.is_img,
            "type" : parametes.type,
            "score" : parametes.score,
            "token" : token
            ] as [String : Any]
        if let images  = parametes.images {
            para["images"] = images
        }
 
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    /// request sign
    func requestTencentSign( _ print : Bool = false ) -> DataRequest? {
        let url  =  DomainType.release.rawValue + "Yuncos/rest"
        let  para = ["type": "0"]
        return performRequest(url: url , method: HTTPMethod.post, parameters: para, print : print )
    }
    
    /*
     let tenxunAppid = "1252043302"
     let tenxunAppKey = "2ae4806abe0f1ae393564456ff1130b5"
     let bukey: String = "hilao"
     let regin: String = "bj"
     http://api.hilao.cc/index/getTencentObjectStorageSignature
     post
     */
    func uploadMediaToTencentYun(image:UIImage ,progressHandler:@escaping ( Int,  Int, Int)->(),compateHandler : @escaping (_ imageUrl:String?)->())  {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath = docuPath  {
            let filePath = realDocuPath + "/tempImage.png"
            let filePathUrl = URL(fileURLWithPath: filePath, isDirectory: true )
            do{
                let _ = try UIImageJPEGRepresentation(image, 0.5)?.write(to: filePathUrl)
                self.requestTencentSign(true)?.responseJSON(completionHandler: { (response) in
                    if let jsonStr = response.value as? String, let model = DDJsonCode.decodeToModel(type: ApiModel<String>.self, from: jsonStr) {
                        if model.status == 200 {
                            var fileNameInServer = "\(Date().timeIntervalSince1970 )"
                            if fileNameInServer.contains("."){
                                if let index = fileNameInServer.index(of: "."){
                                    fileNameInServer.remove(at: index)
                                }
                            }
                            if let sign = model.data {
                                let uploadTask = COSObjectPutTask.init(path: filePath, sign: sign, bucket: "grabcao2", fileName: fileNameInServer, customAttribute: "temp", uploadDirectory: nil, insertOnly: true)
                                
                                self.client?.completionHandler = {(/*COSTaskRsp **/resp, /*NSDictionary */context) in
                                    if let  resp = resp as? COSObjectUploadTaskRsp{
                                        //                            mylog(context)
                                        //                            mylog(resp.descMsg)
                                        //                            mylog(resp.fileData)
                                        //                            mylog(resp.data)
                                        //                            mylog(resp.sourceURL)//发给服务器
                                        //                            mylog(resp.httpsURL)
                                        //                            mylog(resp.objectURL)
                                        
                                        if (resp.retCode == 0) {
                                            //sucess
                                            compateHandler(resp.sourceURL)
                                        }else{
                                            compateHandler(nil)
                                        }
                                    }
                                };
                                self.client?.progressHandler = {( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                                    progressHandler(Int(bytesWritten), Int(totalBytesWritten), Int(totalBytesExpectedToWrite))
                                    //                        mylog("\(bytesWritten)---\(totalBytesWritten)---\(totalBytesExpectedToWrite)")
                                    //progress
                                }
                                self.client?.putObject(uploadTask)
                            }else {
                                compateHandler(nil)
                            }
                            
                            
                            
                            
                            
                            
                        }else {
                            compateHandler(nil)
                        }
                        
                    }
                    
                })
                
                
                
                
            }catch{
                mylog(error)
                compateHandler(nil)
            }
            
            //            let filePath = realDocuPath.append//appendingPathComponent("Account.data")
        }
    }
    
    
}


enum  DDError : Error {
    case timeOut
    case networkError
    case serverError(String?)
    case modelUnconvertable
    case urlUnconvertable
    case noToken
    case otherError(String?)
    case noExpectData(String?)
    var localizedDescription: String{
        switch self  {
        case .networkError:
            return "网络不稳定,请重试"
        case .serverError(let msg):
            return "加载失败"
//            if let errorMsg = msg{
//                return errorMsg
//            }else{
//                return "serverError"
//
//            }
            
        case .modelUnconvertable:
            return "modelUnconvertable"
            
        case .urlUnconvertable:
            return "urlUnconvertable"
            
        case .noToken:
            return "noToken"
        case .otherError(let errMsg):
            return errMsg == nil ? "unknown error" : errMsg!
        case .noExpectData(let msg):
            return "还没有内容"
//            return msg == nil ? "还没有内容" : msg!
        case . timeOut:
            return  "加载失败"
//            return "请求超时"
        }
    }
}

// MARK:   new request method
extension DDRequestManager{
    
    /// GET: http://22t.1818lao.com/Mttuserinfo/getQrcode
    func getAccountQRCode<T>(type : ApiModel<T>.Type, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "Mttuserinfo/getQrcode"
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:nil   , success: success, failure: failure, complate: complate)
    }
    
    ///(1:发起的约定列表;2:接收的约定列表)
    func appointListNew<T>(type : ApiModel<T>.Type,appointType:String, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "Liutest/ylist"
        let para = ["type":appointType]
        
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    func getPartnerListNew<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url = "Weifriendslist/rest"
       return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    
    
    @discardableResult
    func homeApiNew<T>(type : ApiModel<T>.Type ,page: String, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "Weisystemessage/rest"
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:["page":page] , success: success, failure: failure, complate: complate)
    }
    
    ///公开约定详情
    func publicAppointDetailNew<T>(type : ApiModel<T>.Type,order_id:String,user_type:String,bid : String? = nil  , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "Liuopeninfo/Details"
        var para = ["order_id":order_id,"user_type":user_type]
        if let bid = bid {
            para["bid"] = bid
        }
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para , success: success, failure: failure, complate: complate)
    }
    
    ///非公开约定详情
    /// -order_id:约定id   user_type:用户属性(1/2)(收款方/付款方)   bid:乙方id
    func privateAppointDetailNew<T>(type : ApiModel<T>.Type,order_id:String,user_type:String,bid:String? = nil  , success:@escaping (ApiModel<T>)->()  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "Liuinfoone/details_one"
        var para = ["order_id":order_id,"user_type":user_type]
        if let yiID = bid , yiID.count > 0 { para["bid"] = yiID}
        return self.requestServer(type: type , method: HTTPMethod.post, url: url ,parameters:para , success: success, failure: failure, complate: complate)
    }
    
    /*
     获取公开约定列表
     sort    筛选条件   1:最新,2:随时开始,3:人满开始
     range    地区
     page    当前页数  默认第一页
     */
    func getOpenAppiontListAddError<T>(type : ApiModel<T>.Type ,sort:String , range: String, success:@escaping (ApiModel<T>)->()  ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "Liuopen/openlist"
        let para =  [ "sort" : sort , "range" : range, "page" : "1", "keywords": "", ]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url , parameters: para, success: success, failure: failure, complate: complate)
    }
    
    
    
    
    
    
    
    
    
    
    

    func testCallback<T>(type : ApiModel<T>.Type, success:@escaping (ApiModel<T>)->()  ,failure:( (_ error:DDError)->Void )? ,complate:(()-> Void)?) {
        self.requestServer(type: type , method: HTTPMethod.get, url: "url", parameters: ["key":"value"], success: success,failure: failure,  complate: complate)
    }
    

    
    
    /// request server api
    ///
    /// - Parameters:
    ///   - type: model type
    ///   - method: request method
    ///   - url: url
    ///   - parameters: parameters
    ///   - failure: invoke when mistakes
    ///   - success: invoke when success
    ///   - complate: invoke always (failure or success)
    @discardableResult
    private func requestServer<T>(type : ApiModel<T>.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil , success:@escaping (ApiModel<T>)->(),failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
//        let result = networkReachabilityManager?.startListening()
//        mylog("是否  监听  成功  \(result)")
        mylog("\(networkReachabilityManager?.networkReachabilityStatus)")
        if let status = networkReachabilityManager?.isReachable , !status {
////            GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
            failure?(DDError.networkError)
            complate?()
            return nil
        }
        
        let urlFull = DomainType.release.rawValue + url
        var para = Parameters()
        if let parametersUnwrap = parameters{para = parametersUnwrap}
        para["l"] = DDLanguageManager.languageIdentifier
//        para["c"] = DDLanguageManager.countryCode
        para["l"] = "110"
        if urlFull != DomainType.release.rawValue + "Initkey/rest"{//初始化接口不需要token
            if let tokenReal = DDToken {
                para["token"] = tokenReal
            }else{
                mylog("token is nil")
                failure?(DDError.noToken)
                complate?()
                return nil
            }
        }
        
//        let language = DDLanguageManager.countryCode
        let language = "110"
        var header = [String : String]()
        header["APPID"] = "2"
        header["VERSIONMINI"] = "20160501"
        header["DID"] = ZDID
        header["VERSIONID"] = "2.0"
        header["language"] = language
        
        if let url  = URL(string: urlFull){
            let task = DDRequestManager.share.sessionManager.request(url , method: method , parameters: para , headers:header).responseJSON(completionHandler: { (response) in
//                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
                        success(a)
                        complate?()
                    }else{
                        failure?(DDError.modelUnconvertable)
                        complate?()
                    }
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    mylog(response.result.error?.localizedDescription)
                    if let error = response.result.error as? NSError{
                        if error.code == -1001{
                            failure?(DDError.serverError("请求超时"))
                        }else if error.code == -999{
                            failure?(DDError.serverError("取消请求"))
                        }else{
                            if let errorMsg = response.result.error?.localizedDescription {
                                failure?(DDError.serverError(errorMsg))
                            }else{
                                failure?(DDError.otherError(nil))
                            }
                        }
                    }else{
                        if let errorMsg = response.result.error?.localizedDescription {
                            failure?(DDError.serverError(errorMsg))
                        }else{
                            failure?(DDError.otherError(nil))
                        }
                    }
                    complate?()
                }
            })
            return task
        }else{
            failure?(DDError.urlUnconvertable)
            complate?()
            return nil
        }
    }
}







//    func initInfo()   {
//        let url = baseUrl + "init"
//        let did = UIDevice.current.identifierForVendor?.uuidString
//        let para = ["deviceid" : did! , "app_type" : "2" ]
////        Alamofire.request(url , method: HTTPMethod.post, parameters: para ).responsePropertyList{ (result) in
//////                        DefaultDataResponse
////            print("request result : \(result.data)")
////            }.responseString { (response) in
////                print("responseString resulw \(type(of: response.result.va)) data\(response.value)    error \(response.error)")
////        }
//        Alamofire.request(url, method: HTTPMethod.post, parameters: para  ).response(completionHandler: { (response) in
//            print("dataByte : \(response.data)")
//        }).responseJSON(completionHandler: { (response) in
//            print("JSON : \(response)")
//            if let dict = response.value as? [String : AnyObject]{
//                print("DICT : \(dict["status"])")
//            }
//        }).responsePropertyList() { (dataResponse) in
//            print("response : \(dataResponse)")
//        }
//    }
