//
//  DDItem1VC.swift
//  hhcszgd
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import CryptoSwift
import CoreLocation
import AVFoundation
/*
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
{
    //无权限
}
typedef NS_ENUM(NSInteger, AVAuthorizationStatus) {
    AVAuthorizationStatusNotDetermined = 0,// 系统还未知是否访问，第一次开启相机时
    AVAuthorizationStatusRestricted, // 受限制的
    AVAuthorizationStatusDenied, //不允许
    AVAuthorizationStatusAuthorized // 允许状态
} NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;

*/
class DDItem1VC: DDDiyNavibarVC /*, UITextFieldDelegate*/ ,  HomeNaviBarDelegate {
    func readyForScanning() {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status ==  AVAuthorizationStatus.authorized{
            self.scannerAction()
        }else if status == AVAuthorizationStatus.notDetermined{//第一次访问
            self.scannerAction()
        }else{//拒绝
            let alertVC = UIAlertController.init(title: "没有权限访问相机,请前往设置开启", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                
            }
            
            let goSet = UIAlertAction.init(title: "去开启", style: UIAlertActionStyle.default) { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString){
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            alertVC.addAction(cancel)
            alertVC.addAction(goSet)
            self.present(alertVC, animated: true , completion: nil)
        }
        
    }
    func performAction(actionType: DDHomeCustomTitleView.HomeNaviBarActionType) {
        switch actionType {
        ///扫一扫
        case .scanner:
           readyForScanning()
            
        ///发起约定
        case .appoint:
            self.createAppointAction()
        ///加号时间
        case .add:
            self.addBtnClick()
        ///付款
        case .pay:
//            payAction()
            self.addPartner()
        ///搜索
        case .search:
         self.searchAction()
        ///搜索
        case .bannerAction:
            mylog("banner action")
            if let url =  self.apiModel?.data?.float_img?.url{
                self.navigationController?.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: url)
            }
//            self.bannerFirstShow = false
//            UIView.animate(withDuration: 0.01, animations: {
//                self.tableView.contentInset = UIEdgeInsetsMake(self.scrollCritical, 0, 0, 0)
//                self.customNav.bannerModel = nil
//            }) { (bool ) in
//                self.tableView.gdRefreshControl?.originalContentInset = UIEdgeInsetsMake(self.scrollCritical, 0, 0, 0)
//                self.tableView.reloadData()
//            }
        }
    }
    
    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 0
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var collectionView : UICollectionView?
    var apiModel : ApiModel<DDHomeApiDataModel>?
//    let searchBox = UITextField.init()
    var scanner  : QRCodeScannerVC?
    let customNav = DDHomeCustomTitleView()
    var cover  : GDCoverView?
    var bannerFirstShow = true
    var advertCorverFirstShow = true
    let tipsLabel = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar = customNav
        customNav.delegate = self
        self.naviBar!.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: DDStatusBarHeight + 128)
        scrollCritical = 128 * 0.6
//        self.naviBar.addSubview(customNav)
//        customNav.frame = self.naviBar.bounds
//        let mi = Mirror.init(reflecting: self)
//        for i  in mi.children {
//            mylog(i)
//        }
        configNaviBar()
        self.configTableView()
//        requestHomeApi(loadType: .initialize)
//        setRealName()
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "nil" , style: UIBarButtonItemStyle.plain, target: nil   , action:  nil)//去掉title
        
        NotificationCenter.default.addObserver(self , selector: #selector(reloadData), name: GDReloadMessageList, object: nil )
    }
    
    @objc func reloadData() {
        self.requestHomeApi(loadType: LoadDataType.initialize)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self )
    }
    
    func setRealName()  {
        DDRequestManager.share.setRealName(type: ApiModel<String>.self, name: "张大炮") { (model) in
//            dump(model)
        }
    }
    /*
    
    if self.apiModel?.data?.count ?? 0 <= 0{
    let attributeTitle = ["对不起，您还没有添加伙伴","\n点击添加"].setColor(colors: [UIColor.lightGray , UIColor.blue])
    self.tipsLabel.setAttributedTitle(attributeTitle, for: UIControlState.normal)
    self.tipsLabel.isHidden = true
    self.tipsLabel.addTarget(self , action: #selector(self.performAddFriends), for: UIControlEvents.touchUpInside)
    self.tipsLabel.isHidden = false
    //                GDAlertView.alert("没有找到符合搜索条件的内容。", image: nil , time: 3, complateBlock: nil )
    self.navigationItem.rightBarButtonItem?.isEnabled = false
    }else{
    self.tipsLabel.isHidden = true
    self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    */
    func requestHomeApi(loadType : LoadDataType){
        ///页码从0开始
        if loadType == LoadDataType.initialize || loadType == LoadDataType.reload{
            self.pageNum = 0
        }else{
            self.pageNum += 1
        }
        DDRequestManager.share.homeApiNew(type:  ApiModel<DDHomeApiDataModel>.self, page:  "\(self.pageNum)", success: { (model ) in
            if loadType == LoadDataType.initialize || loadType == LoadDataType.reload{
                if loadType == LoadDataType.initialize{
                    
                    if model.data?.message?.count ?? 0 <= 0{
                        let errorView = DDErrorView(superView: self.view , error: DDError.noExpectData("暂 无 消 息"))
                        errorView.frame = CGRect(x: 0, y: self.customNav.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - self.customNav.bounds.height - DDTabBarHeight)
                        errorView.automaticRemoveAfterActionHandle = {
                            self.requestHomeApi(loadType: LoadDataType.initialize)
                        }
                        self.view.bringSubview(toFront: self.customNav)
                        self.view.bringSubview(toFront: self.customNav.bannerView)
                    }
                }
                if model.status  == 200 {
                    self.apiModel = model
                    
                }else{
                    if model.status  != 3032{
                        GDAlertView.alert(model.message, image: nil , time: 2, complateBlock:  nil )
                    }
                }
                self.setDataToNavibar(para: model.data?.float_img)//设置完contentInset之后再设置刷新控件
                self.tableView.reloadData()
                self.tableView.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    //                    self.setDataToAdCorver(para: model?.data?.float_img)
                    self.setDataToAdCorver(para: model.data?.banners)
                })
            }else{
                if model.status  == 200 {
                    if let messages = model.data?.message{
                        self.apiModel?.data?.message?.append(contentsOf: messages)
                    }
                    
                }else{
                    GDAlertView.alert(model.message, image: nil , time: 2, complateBlock:  nil )
                }
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                //                self.setDataToNavibar(para: model?.data?.banners)//设置完contentInset之后再设置刷新控件
                self.setDataToNavibar(para: model.data?.float_img)//设置完contentInset之后再设置刷新控件
                self.tableView.reloadData()
            }
            
            
        }, failure: { (error ) in
            let errorView = DDErrorView(superView: self.view , error: error)
            errorView.frame = CGRect(x: 0, y: self.customNav.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - self.customNav.bounds.height - DDTabBarHeight)
            errorView.automaticRemoveAfterActionHandle = {
                self.requestHomeApi(loadType: LoadDataType.initialize)
            }
            self.view.bringSubview(toFront: self.customNav)
            self.view.bringSubview(toFront: self.customNav.bannerView)
        }) {
            //完成
            self.tableView.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
            self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
            self.setDataToNavibar(para: self.apiModel?.data?.float_img)//设置完contentInset之后再设置刷新控件
            self.tableView.reloadData()
        }
        
        
    }
    /*
    func requestHomeApi(loadType : LoadDataType){
        ///页码从0开始
        if loadType == LoadDataType.initialize || loadType == LoadDataType.reload{
            self.pageNum = 0
        }else{
            self.pageNum += 1
        }
        DDRequestManager.share.homeApi(type: ApiModel<DDHomeApiDataModel>.self , page: "\(self.pageNum)") { (model ) in

            if loadType == LoadDataType.initialize || loadType == LoadDataType.reload{
                if loadType == LoadDataType.initialize{
                    
                    if model?.data?.message?.count ?? 0 <= 0{
                        let attributeTitle = ["对不起，您还没有消息","\n点击刷新"].setColor(colors: [UIColor.lightGray , UIColor.blue])
                        self.tipsLabel.setAttributedTitle(attributeTitle, for: UIControlState.normal)
                       
                        self.tipsLabel.isHidden = false
                        GDAlertView.alert("对不起，您还没有消息", image: nil , time: 3, complateBlock: nil )
                    }else{
                        self.tipsLabel.isHidden = true
                    }
                }
                if model?.status ?? 0 == 200 {
                    self.apiModel = model
                    
                }else{
                    if model?.status ?? 0 != 3032{
                        GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock:  nil )                        
                    }
                }
                //            dump(model)
//                self.setDataToNavibar(para: model?.data?.banners)//设置完contentInset之后再设置刷新控件
                self.setDataToNavibar(para: model?.data?.float_img)//设置完contentInset之后再设置刷新控件
                self.tableView.reloadData()
                self.tableView.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
//                    self.setDataToAdCorver(para: model?.data?.float_img)
                    self.setDataToAdCorver(para: model?.data?.banners)
                })
            }else{
                if model?.status ?? 0 == 200 {
                    if let messages = model?.data?.message{
                        self.apiModel?.data?.message?.append(contentsOf: messages)
                    }
                    
                }else{
                    GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock:  nil )
                }
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
//                self.setDataToNavibar(para: model?.data?.banners)//设置完contentInset之后再设置刷新控件
                self.setDataToNavibar(para: model?.data?.float_img)//设置完contentInset之后再设置刷新控件
                self.tableView.reloadData()
            }
        }
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true  , animated: true )
        self.requestHomeApi(loadType: LoadDataType.initialize)
        DDNotification.postNetworkChanged(networkStatus: (oldStatus: true, newStatus: true))
        self.navigationController?.navigationBar.backItem
        
    }
    func configTableView() {
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.frame = CGRect(x:0 , y :self.naviBar!.frame.height - self.scrollCritical , width : self.view.bounds.width , height : self.view.bounds.height - self.naviBar!.frame.height - DDTabBarHeight + self.scrollCritical)
        self.view.addSubview(tableView)
        self.addObservers(scrollView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        tableView.gdLoadControl?.loadHeight = 40
//            tableView.gdRefreshControl?.refreshHeight = 60
////        self.setDataToNavibar(para: "")//设置完contentInset之后再设置刷新控件
//        tableView.gdRefreshControl = GDRefreshControl.init(target: self , selector: #selector(refreshData))
//        tableView.gdRefreshControl?.refreshHeight = 60
        
        
        
        
        self.view.addSubview(tipsLabel)
        self.tipsLabel.isHidden = true
        tipsLabel.titleLabel?.numberOfLines = 2
//        tipsLabel.setTitle("暂时没有收到消息", for: UIControlState.normal)
        tipsLabel.titleLabel?.textAlignment = .center
        self.tipsLabel.bounds = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT - DDTabBarHeight - naviBarStartShowH)
        self.tipsLabel.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2 + 40)
        
         self.tipsLabel.addTarget(self , action: #selector(clickForGettingNewMessage), for: UIControlEvents.touchUpInside)
    }
    @objc func clickForGettingNewMessage() {
        self.requestHomeApi(loadType: LoadDataType.initialize)
    }
    func setDataToAdCorver(para : DDHomeAdvertModel?)  {
        if let image = para?.img , advertCorverFirstShow{
            self.advertCorverFirstShow = false
//            let image = "https://gss0.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=4ebd3de61d178a82ce6977a6c6335fb5/c83d70cf3bc79f3d3447231ab9a1cd11728b2972.jpg"
            let corver = DDHomeADCorver.init(superView: self.view )
            corver.model =  (img: image , actionType: 0)
            corver.actionHandle = {donePara  in
                mylog(donePara)
                if let url =  self.apiModel?.data?.banners?.url{
                    self.navigationController?.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: url)
                }
            }
        }

        
    }
    func setDataToNavibar(para:DDHomeAdvertModel?)  {
        if  para?.img != nil && self.bannerFirstShow{//有广告
            self.customNav.bannerModel = para
            self.tableView.contentInset = UIEdgeInsetsMake(scrollCritical + 30, 0, 0, 0)
            self.tableView.gdRefreshControl?.originalContentInset = UIEdgeInsetsMake(self.scrollCritical + 30, 0, 0, 0)
        }else{//无广告
            self.customNav.bannerModel = nil
            self.tableView.contentInset = UIEdgeInsetsMake(scrollCritical, 0, 0, 0)
            self.tableView.gdRefreshControl?.originalContentInset = UIEdgeInsetsMake(self.scrollCritical, 0, 0, 0)
        }
        //设置完contentInset之后再设置刷新控件
        if tableView.gdRefreshControl == nil  {
            tableView.gdRefreshControl = GDRefreshControl.init(target: self , selector: #selector(refreshData))
            tableView.gdRefreshControl?.refreshHeight = 40
        }
    }
    
    @objc func loadMore()  {
        requestHomeApi(loadType: LoadDataType.loadMore)
        
    }
    
    @objc  func refreshData()  {
        mylog("perform refresh")
        requestHomeApi(loadType: LoadDataType.reload)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//            self.tableView.gdRefreshControl?.endRefresh()
//        }
    }
    override func contentOffsetChanged(scrollView : UIScrollView ,contentOffset : CGPoint) {
//                mylog("监听contentOffsetChanged\(contentOffset)")
        var scale : CGFloat = 0
        
        if contentOffset.y + scrollView.contentInset.top > self.scrollCritical {
//            mylog(contentOffset.y)
            var  bannerViewMoveScale = (30 + contentOffset.y)  / 30
//            mylog(bannerViewMoveScale)
            if bannerViewMoveScale > 1 {bannerViewMoveScale = 1}
            self.customNav.hideStatus(scale: bannerViewMoveScale)
            scale = 1
        }else if  contentOffset.y + scrollView.contentInset.top < 0 {
            scale = 0
        }else{
            scale = (contentOffset.y + scrollView.contentInset.top) / self.scrollCritical
        }
        self.customNav.switchStatus(scale: scale)
    }
    func configNaviBar() {
//        self.title = "首页"

    }
//    func jianbian(view:UIView?)  {
//        let colorlayer: CAGradientLayer = CAGradientLayer()
//        colorlayer.startPoint = CGPoint(x: 0, y: 0.5)
//        colorlayer.endPoint = CGPoint(x: 1, y: 0.5)
//        let startColor = UIColor.red.cgColor
//        let midColor  = UIColor.green.cgColor
//        let endColor = UIColor.blue.cgColor
//        colorlayer.colors = [startColor,midColor,endColor]
//        colorlayer.frame = view?.bounds ?? CGRect.zero
//        view?.layer.addSublayer(colorlayer)
//    }
    //textfieldDelegate
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
//        self.navigationController?.pushViewController(DDUserSearchVC(), animated: true)
//        return false
//    }
    

}

///{'type':'1','id':'2','name':"昵称",'mobile':'1593911291','head_images':"a.jpg"}
///'type':'1' 代表用户二维码
///'type':'2' 代表url二维码
class QRCodeModel : Decodable{
    var type : String?
    var id : String?
    var mobile : String?
    var head_images : String?
    var name : String?
}
// MARK: - actions
extension DDItem1VC{
    func scannerAction() {
        let vc = QRCodeScannerVC()
//        vc.delegate = self
        vc.completeHandle = {[weak self ] resultStr in
            self?.navigationController?.popViewController(animated: true )
            
//            GDAlertView.alert(resultStr , image:nil  , time: 3, complateBlock: nil )
            
            if let decodeResult = String.AESDecode(codeStr: resultStr){
                let result  = DDJsonCode.decode(QRCodeModel.self, from: decodeResult.data(using: String.Encoding.utf8))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                    if let type = result?.type {
                        if type == "1" {//用户
                            let id = result?.id ?? "8135"
                            self?.navigationController?.pushVC(vcIdentifier: "DDPartnerDetailVC", userInfo: ["type":DDPartnerDetailVC.DDPartnerDetailFuncType.addFriend , "id":id] )
                        }else if type == "2"{//url
                            
                        }
                    }else{
                        GDAlertView.alert("该二维码不是一把通好友二维码，请选择官方二维码扫描" , image:nil  , time: 3, complateBlock: nil )
                    }
                })
                
            }else{
                GDAlertView.alert("该二维码不是一把通好友二维码，请选择官方二维码扫描" , image:nil  , time: 3, complateBlock: nil )
            }
            
        }
        self.navigationController?.pushViewController(vc, animated: true )
    }
    func goPartnerListAction(appointType: DDAppointType) {
        let vc = DDPartnerListVC()
        vc.appointType = appointType
        self.navigationController?.pushViewController(vc, animated: true )
    }
    func addPartner()  {
        
        self.navigationController?.pushViewController(DDUserSearchVC(), animated: true)
    }
    func searchAction() {
        self.navigationController?.pushViewController(DDHomeSearchVC(), animated: true)
    }
    func payAction() {
        mylog("pay")
        self.navigationController?.pushVC(vcIdentifier: "DDChooseToPay")
//        self.navigationController?.pushViewController(DDPartnerListVC(), animated: true )
    }
    
    func createAppointAction() {
        //        self.navigationController?.pushViewController(DDPartnerListVC(), animated: true )
        if (DDAccount.share.nickname == nil) || (DDAccount.share.nickname == "未设置") {
//            GDAlertView.alert("请设置用户名", image: nil, time: 2 , complateBlock: nil)
            let alertVC = UIAlertController.init(title: "尚未填写真实姓名", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                
            }
            
            let goSet = UIAlertAction.init(title: "去填写", style: UIAlertActionStyle.default) { (action) in
                self.navigationController?.pushVC(vcIdentifier: "NameVC", userInfo: VCActionType.changeName)
            }
            alertVC.addAction(cancel)
            alertVC.addAction(goSet)
            self.present(alertVC, animated: true , completion: nil)
        }else{
            let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let singel = UIAlertAction(title: "一次约定", style: UIAlertActionStyle.default) { (action ) in
                mylog("一次约定")
                self.goPartnerListAction(appointType: DDAppointType.single)
            }
            
            let smart = UIAlertAction(title: "智能约定", style: UIAlertActionStyle.default) { (action ) in
                mylog("智能约定")
                self.goPartnerListAction(appointType: DDAppointType.smart)
            }
            let _public = UIAlertAction(title: "公开约定", style: UIAlertActionStyle.default) { (action ) in
                mylog("公开约定")
                self.navigationController?.pushViewController(DDPublicAppointPostVC(), animated: true)
            }
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action ) in
                mylog("取消")
            }
            alertVC.addAction(singel)
            alertVC.addAction(smart)
            alertVC.addAction(_public)
            alertVC.addAction(cancel)
            self.present(alertVC, animated: true) {
                
            }
        }
        
    }
    func getCashAction(){
        mylog("get cash")
        
        self.navigationController?.pushVC(vcIdentifier: "DDGetCashVC")
    }
}

extension DDItem1VC {
    @objc func corverItemClick(sender:UIButton){
        mylog(sender.tag)
        //to do something
        switch sender.tag {
        case 0:
           readyForScanning()
        case 1:
            createAppointAction()
        case 2:
            self.addPartner()
            
        case 3:
            self.payAction()
        case 4:
            self.getCashAction()
            
        default:
            break
        }
        self.cover?.remove()
        self.cover = nil
    }
    @objc func addBtnClick(){
        if self.cover != nil {
            conerClick(sender: self.cover!)
            return
        }
//        let titles = [" 扫一扫"," 发起约定"," 添加伙伴"," 直接付款"," 提  现"]修改
        let titles = [" 扫一扫"," 发起约定"," 添加伙伴"]
//        let titles = [" 扫一扫"," 发起约定"," 添加伙伴"," 直接付款"]
        // ****************  wangyuanfei  **********************
//        let imageNames = ["scan_icon_small","convention_icon_small","addpartnericons 2","payment_icon_small","withdrawal_icon 2"]//修改
        let imageNames = ["scan_icon_small","convention_icon_small","addpartnericons 2"]
//        let imageNames = ["scan_icon_small","convention_icon_small","addpartnericons 2","payment_icon_small"]
        // *****************************************************
//        let imageNames = ["withdrawal_icon 2","withdrawal_icon 2","withdrawal_icon 2","withdrawal_icon 2","withdrawal_icon 2"]
        cover = GDCoverView.init(superView: self.view)
        cover?.addTarget(self , action: #selector(conerClick(sender:)) , for: UIControlEvents.touchUpInside)
        //            cover?.layoutViewToBeShow(action: { () in
        let buttonH : CGFloat = 36
        for index in 0..<titles.count{
            let button  = DDAlertButton.init(frame:CGRect(x: SCREENWIDTH, y: DDNavigationBarHeight + CGFloat(44 * index), width: 88, height: buttonH))
            button.tag = index
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
            button.addTarget(self , action: #selector(corverItemClick(sender:)), for: UIControlEvents.touchUpInside)
            cover?.addSubview(button)
            button.backgroundColor = UIColor.DDThemeColor
            button.setTitle(titles[index], for: UIControlState.normal)
            button.setImage(UIImage(named:imageNames[index]), for: UIControlState.normal)
            if index == titles.count - 1 {
                button.isHiddenBottomLine = true
            }
        }
        for (index ,view) in (self.cover?.subviews.enumerated())!{
            UIView.animate(withDuration: 0.3, delay: TimeInterval(CGFloat(index) * 0.05), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                view.frame = CGRect(x: SCREENWIDTH - 88 , y: DDNavigationBarHeight + buttonH * CGFloat(index), width: 88, height: buttonH)
            }, completion: { (bool ) in
                
            })
        }
        
    }
    
    @objc func conerClick(sender : GDCoverView)  {
        for (index ,view) in sender.subviews.enumerated(){
            UIView.animate(withDuration: 0.3, delay: TimeInterval(CGFloat(index) * 0.05), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                view.frame = CGRect(x: SCREENWIDTH + 22 , y: DDNavigationBarHeight + CGFloat(44 * index), width: 88, height: 40)
            }, completion: { (bool ) in
                sender.remove()
                self.cover = nil
            })
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cover = self.cover{
            self.conerClick(sender: cover)
        }
    }
}
extension DDItem1VC : QRCodeScannerVCDelegate{
    func scannerComplate(code: String?) {
//        GDAlertView.alert(code, image: nil , time: 3, complateBlock: nil )
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.randomColor()
        self.navigationController?.pushViewController(vc , animated: true )
//        self.navigationController?.viewControllers.remove(at: <#T##Int#>)

    }
}
extension DDItem1VC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let para = ["messageID" : self.apiModel?.data?.message?[indexPath.row].id , "title": self.apiModel?.data?.message?[indexPath.row].title]
        self.navigationController?.pushVC(vcIdentifier: "DDSystemMsgVC", userInfo: para)
        if let cell = tableView.cellForRow(at: indexPath) as? HomeCell,let model = self.apiModel?.data?.message?[indexPath.row]{
            model.read_status = "1"
            cell.model = model
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiModel?.data?.message?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempCell : HomeCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell{
            tempCell = cell
        }else{
            tempCell  = HomeCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "HomeCell")
        }
        tempCell.model = self.apiModel?.data?.message?[indexPath.row]
        return tempCell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        switch editingStyle {
        case .delete:
            mylog("delete")
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let action = UITableViewRowAction.init(style: UITableViewRowActionStyle.default, title: "删\n除") { (action , indexPath ) in
            mylog("delete action")
            DDRequestManager.share.deleteHomeMessage(type: ApiModel<String>.self, mid:  self.apiModel?.data?.message?[indexPath.row].id ?? "", complate: { (model ) in
                if model?.status ?? 0  == 200 {
                    self.apiModel?.data?.message?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }else{
                    GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil )
                }
            })
        }
        action.backgroundColor = UIColor.DDThemeColor
        return [action]
    }
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
//        return "d\nel"
//    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
//        let action1 = UITableViewRowAction.init(style: UITableViewRowActionStyle.default, title: "delete") { (action , indexPath) in
//            mylog("delete")
//        }
//        action1.backgroundColor = UIColor.DDThemeColor
//        return [action1]
//    }
}
class HomeCell : UITableViewCell {
    let icon  = UIImageView()
    let title = UILabel()
    let subTitle = UILabel()
    let redPoint = UIView()
    let time = UILabel()
    let bottomLine = UIView()
    var model : DDHomeMessageModel?{
        didSet{
            title.text = model?.title ?? "占位"
            subTitle.text = model?.content ?? "占位"
            time.text = model?.create_at ?? "占位"
            self.icon.setImageUrl(url: model?.logo)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.contentView.backgroundColor = UIColor.randomColor()

        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(subTitle)
        self.contentView.addSubview(redPoint)
        self.contentView.addSubview(time)
        self.contentView.addSubview(bottomLine)
        
        redPoint.backgroundColor = UIColor.DDThemeColor
        title.textColor = UIColor.DDTitleColor
        subTitle.textColor = UIColor.DDSubTitleColor
        time.textColor = UIColor.DDSubTitleColor
        
        title.font = GDFont.systemFont(ofSize: 17)
        subTitle.font = GDFont.systemFont(ofSize: 15)
        time.font = GDFont.systemFont(ofSize: 13)
        
        bottomLine.backgroundColor = UIColor.DDLightGray
//        icon.image = UIImage(named: "groupchatbackground")
//        icon.image = QRCodeScannerVC.creatQRCode(string: "this qrCode is created by wyf", imageToInsert: UIImage(named: "groupchatbackground"))
//        title.text = "姓名"
//        subTitle.text = "约定名称"
//        time.text = "约定时间"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        let bottomLineH : CGFloat = 2
        let iconWH = self.bounds.height - margin * 2 - bottomLineH
        icon.frame = CGRect(x: margin , y: margin , width:iconWH, height:iconWH )
        time.ddSizeToFit()
        title.ddSizeToFit()
        subTitle.ddSizeToFit()
        time.frame = CGRect(x: self.bounds.width - margin * 2 - time.bounds.width, y: icon.frame.minY, width: time.bounds.width, height: time.bounds.height)
        let redPointWH : CGFloat = 8
        redPoint.frame = CGRect(x: time.frame.maxX + margin/4 , y:time.frame.minY - redPointWH/2, width: redPointWH, height: redPointWH)
        title.frame = CGRect(x: icon.frame.maxX + margin, y: icon.frame.minY, width: time.frame.minX - margin - icon.frame.maxX - margin , height: title.bounds.height)
        subTitle.frame = CGRect(x: title.frame.minX, y: icon.frame.maxY - subTitle.bounds.height, width: self.bounds.width - margin * 2 - icon.frame.maxX, height: subTitle.bounds.height)
        bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
        redPoint.layer.cornerRadius = redPointWH/2
        redPoint.layer.masksToBounds = true
        if self.model?.read_status ?? "" == "0"{//未读
            redPoint.isHidden = false
        }else{
            redPoint.isHidden = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
