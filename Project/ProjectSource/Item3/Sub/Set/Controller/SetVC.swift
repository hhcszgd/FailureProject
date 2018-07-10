//
//  SetVC.swift
//  Project
//
//  Created by wy on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class SetVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "设置")
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        let rowW: CGFloat = SCREENWIDTH - 30
        self.feedback.frame = CGRect.init(x: 15, y: DDNavigationBarHeight + 15, width: SCREENWIDTH - 30, height: 44)
        self.cleanCaching.frame = CGRect.init(x: 15, y: self.feedback.max_Y + 1, width: rowW, height: 44)
        self.userProtocal.frame = CGRect.init(x: 15, y: self.cleanCaching.max_Y + 1, width: rowW, height: 44)
        self.privacy.frame = CGRect.init(x: 15, y: self.userProtocal.max_Y + 1, width: rowW, height: 44)
        
        
        self.aboutWe.frame = CGRect.init(x: 15, y: self.privacy.max_Y + 1, width: rowW, height: 44)
        self.view.addSubview(self.feedback)
        self.view.addSubview(self.cleanCaching)
        self.view.addSubview(self.userProtocal)
        self.view.addSubview(self.privacy)
        
        
        
        self.view.addSubview(self.aboutWe)
        self.view.addSubview(self.loginoutBtn)
        self.loginoutBtn.frame = CGRect.init(x: (SCREENWIDTH - 200) /  2.0, y: self.aboutWe.max_Y + 20, width: 200, height: 40)
        let btnArr = [self.feedback, self.cleanCaching, self.userProtocal, self.privacy, self.aboutWe]
        btnArr.forEach { (btn) in
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        }
        self.feedback.title = "用户反馈"
        let cach = SDImageCache.shared().getSize() / 1024 / 1024
        let cachStr = String.init(format: " (%dMB)", cach)
        let str = "清理缓存" + cachStr
        let attribute = NSMutableAttributedString.init(string: "清理缓存" + cachStr)
        attribute.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], range: NSRange.init(location: 4, length: str.count - 4))
        self.cleanCaching.titleLabel.attributedText = attribute
        self.userProtocal.title = "用户协议"
        self.aboutWe.title = "关于我们"
        self.privacy.title = "隐私政策"

        // Do any additional setup after loading the view.
    }
    
    @objc func btnClick(sender: DDRowView) {
        switch sender {
        case self.feedback:
            mylog("用户反馈")
            let feed = FeedBackVC()
            self.navigationController?.pushViewController(feed, animated: true)
        case self.cleanCaching:
            mylog("清理缓存")
            SDImageCache.shared().clearDisk()
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().cleanDisk()
            let cach = SDImageCache.shared().getSize() / 1024 / 1024
            let cachStr = String.init(format: " (%dMB)", cach)
            let str = "清理缓存" + cachStr
            let attribute = NSMutableAttributedString.init(string: "清理缓存" + cachStr)
            attribute.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], range: NSRange.init(location: 4, length: str.count - 4))
            sender.titleLabel.attributedText = attribute
            
            
            
        case self.userProtocal:
            mylog("用户协议")
            let web = SetWebVC()
            web.userInfo = BaseUrlStr.api.rawValue + "Fcontent?language=110"
            self.navigationController?.pushViewController(web, animated: true)
        
        case self.privacy:
            mylog("隐私政策")
            let id = DDAccount.share.id ?? ""
            let web = SetWebVC()
            web.userInfo = BaseUrlStr.api.rawValue + "Fcontent?language=110&id=\(2)"
            self.navigationController?.pushViewController(web, animated: true)
        case self.aboutWe:
            mylog("关于我们")
            let aboutVC = AboutWeVC()
            self.navigationController?.pushViewController(aboutVC, animated: true)
        default:
            break
        }
    }
   
    ///退出登录
    @objc func loginOut(btn: UIButton) {
        mylog("退出")
        let router = Router.post("Mttupdateinfo/setLoginout", .api, nil, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                DDAccount.share.deleteAccountFromDisk()
                DDNotification.postLoginSuccess()
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
//        DDAccount.share.setPropertisOfShareBy(otherAccount: model.data)

    }
    lazy var loginoutBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 38))
        btn.setTitle("退出登录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(loginOut(btn:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("6a96fc")
        return btn
    }()
    
    let feedback = DDRowView.init(frame: CGRect.zero)
    let cleanCaching = DDRowView.init(frame: CGRect.zero)
    let userProtocal = DDRowView.init(frame: CGRect.zero)
    let aboutWe = DDRowView.init(frame: CGRect.zero)
    let privacy = DDRowView.init(frame: CGRect.zero)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class SetWebVC: HomeWebVC {
    override func layoutsubviews() {
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.configuration.preferences.javaScriptEnabled = true
        self.webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        //        self.webView.allowsBackForwardNavigationGestures = true //会出现不愿看到的返回列表
        //- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;
        self.webView.configuration.userContentController.add(self , name : "ylcm")//传值的关键 , 释放的时候记得移除
        
        
        var  webViewY = 64
        if DDDevice.type == .iphoneX {webViewY = 88}
        var webViewH = UIScreen.main.bounds.height - DDNavigationBarHeight
        if self.isFirstVCInNavigationVC{
            if DDDevice.type == .iphoneX {webViewH -= 83}else{
                webViewH -= 44
            }
        }else{
            if DDDevice.type == .iphoneX {webViewH -= 34}
        }
        
        self.webView.frame = CGRect(x: 0.0, y: DDNavigationBarHeight, width: UIScreen.main.bounds.width, height: webViewH)
        //        guard let model = self.showModel else {
        //            //            mylog("webViewController的关键模型为nil\(self.showParameter)")
        //            return
        //        }
        //        guard let keyParamete = self.showModel?.keyParameter else {
        //            //            mylog("webViewController的模型关键参数为空\(self.showParameter)")
        //            return
        //        }
        guard let urlStr = self.userInfo as? String else {
            //            mylog("webViewController对应的url字符串不存在\(self.showParameter)")
            return
        }
        //        print(GDNetworkManager.shareManager.token)
        if let  urlstring = self.userInfo as? String  {
            guard let url  = URL.init(string: urlstring  ) else {
                mylog("webViewController的urlStr字符串转换成URL失败")
                return
            }
            
            let urlRequest = URLRequest.init(url: url)
            self.webView.load(urlRequest)
            
        }
    }
}


