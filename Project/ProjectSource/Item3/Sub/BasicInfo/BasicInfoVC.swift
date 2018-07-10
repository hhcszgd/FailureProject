//
//  BasicInfoVC.swift
//  Project
//
//  Created by wy on 2018/4/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class BasicInfoVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "基本信息")
        self.congfingUserImage()
        self.configAccount()
        self.configName()
        self.configPhone()
        self.configCode()
        let viewArr = [self.userImage, self.account, self.name, self.phone, self.code]
        viewArr.forEach { (userView) in
            userView.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        }
        
        let router = Router.get("Mttuserinfo/index", .api, nil, nil)
        NetWork.manager.requestData(router: router, type: DDAccount.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                DDAccount.share.setPropertisOfShareBy(otherAccount: model.data)
                
                self.account.subTitle = DDAccount.share.username
                self.name.subTitle = DDAccount.share.nickname
                self.phone.subTitle = DDAccount.share.mobile
                self.userImage.subImageView.sd_setImage(with: imgStrConvertToUrl(DDAccount.share.headImage ?? ""))
                
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            
        }, onCompleted: {
//            mylog("结束")
        }) {
            mylog("回收")
        }
        
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.account.subTitle = DDAccount.share.username
        self.name.subTitle = DDAccount.share.trueName
        self.phone.subTitle = DDAccount.share.mobile
        if let img = DDAccount.share.headImage, img.count > 0 {
            self.userImage.subImageView.sd_setImage(with: imgStrConvertToUrl(img), placeholderImage: UIImage.init(), options: SDWebImageOptions.retryFailed)
            
        }
        
    
    }
    
    
    
    @objc func clickAction(sender: DDRowView) {
        switch sender {
        case self.userImage:
            //上传图片
            mylog("上传图片")
            self.uploadPicture()
        case self.account:
            mylog("设置用户信息")
            self.navigationController?.pushVC(vcIdentifier: "AccountVC", userInfo: nil)
        case self.name:
            if let name = DDAccount.share.nickname, name.count >= 2, name != "未设置" {
                GDAlertView.alert("姓名不能修改", image: nil, time: 1, complateBlock: nil)
                return
            }
            let vc = NameVC()
            vc.userInfo = VCActionType.changeName
            self.navigationController?.pushViewController(vc, animated: true)
            mylog("设置名字")
        case self.phone: 
            mylog("设置手机号")
            let vc = PhoneVC()
            vc.userInfo = VCActionType.changeUserMobile
            self.navigationController?.pushViewController(vc, animated: true)
        case self.code:
            mylog("设置二维码")
            let vc = TwoCodeVC()
            vc.userInfo = ""
            self.navigationController?.pushViewController(vc, animated: true)
//            self.navigationController?.pushVC(vcIdentifier: "TwoCodeVC", userInfo: nil)
        default:
            break
        }
    }
    
    
    
    
    let rowH: CGFloat = 44
    let rowW: CGFloat = SCREENWIDTH - 30
    let userImage = DDRowView.init(frame: CGRect.zero)
    let account = DDRowView.init(frame: CGRect.zero)
    let name = DDRowView.init(frame: CGRect.zero)
    let phone = DDRowView.init(frame: CGRect.zero)
    let code = DDRowView.init(frame: CGRect.zero)
    
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

    let upload = UploadPicturesTool.init()
}
let userImagePlace = UIImage.init(named: "men_icon")!
extension BasicInfoVC {
    func congfingUserImage() {
        self.userImage.frame = CGRect.init(x: 15, y: DDNavigationBarHeight + 15, width: rowW, height: 70 * SCALE)
        self.userImage.titleLabel.text = "头像"
        self.userImage.additionalImageView.isHidden = false
        self.userImage.subImageView.image = userImagePlace
        self.view.addSubview(self.userImage)
    }
    
    func configAccount() {
        self.account.frame = CGRect.init(x: 15, y: self.userImage.max_Y + 1, width: rowW, height: rowH)
        self.account.titleLabel.text = "账号"
        self.account.additionalImageView.isHidden = true
        self.account.subTitleLabel.textColor = UIColor.colorWithHexStringSwift("333333")

        self.account.subTitleLabel.text = "186808543954"
        self.view.addSubview(self.account)
        
    }
    func configName() {
        self.name.frame = CGRect.init(x: 15, y: self.account.max_Y + 1, width: rowW, height: rowH)
        self.name.titleLabel.text = "姓名"
        self.name.additionalImageIsHidden = false
        self.name.subTitleText = "***"
        self.view.addSubview(self.name)
        
    }
    func configPhone() {
        self.phone.frame = CGRect.init(x: 15, y: self.name.max_Y + 1, width: rowW, height: rowH)
        self.phone.titleLabel.text = "手机号码"
        self.phone.additionalImageIsHidden = false
        self.phone.subTitleText = "***"
        self.view.addSubview(self.phone)
    }
    func configCode() {
        self.code.frame = CGRect.init(x: 15, y: self.phone.max_Y + 1, width: rowW, height: rowH)
        self.code.titleLabel.text = "我的二维码"
        self.code.additionalImageIsHidden = true
        self.code.subImageView.image = UIImage.init(named: "two-dimensionalcodeIcon")
        self.view.addSubview(self.code)
    }
    ///上传头像
    
    
    func uploadPicture() {
        
        upload.current = self
        upload.changeHeadPortrait()
        upload.finished = { (image) in
            if let img = image {
                DDRequestManager.share.uploadMediaToTencentYun(image: img, progressHandler: { (a, b, c) in
                    
                    
                    
                    
                }, compateHandler: { (imageStr) in
                    guard let str = imageStr else {
                        return
                    }
                    DDAccount.share.headImage = str
                    DDAccount.share.save()
                    
                    let router = Router.put("Mttupdateinfo/updatehead", .api, ["head": str], nil)
                    NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
                        if model.status == 200 {
                            self.userImage.subImageView.sd_setImage(with: imgStrConvertToUrl(str))
                            GDAlertView.alert("图片上传成功", image: nil, time: 1, complateBlock: nil)
                        }
                    }, onError: { (error) in
                        
                    }, onCompleted: {
                        mylog("结束")
                    }, onDisposed: {
                        mylog("回收")
                    })
                    
                })
            }
            
        }
        
        
    }
    
}


