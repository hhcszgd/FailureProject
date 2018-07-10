//
//  DDAddFriendVC.swift
//  Project
//
//  Created by WY on 2018/7/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAddFriendVC: DDNormalVC {
    let searchBar : UISearchBar = UISearchBar()
    let profileInfoButton = UIButton()
    let backWhiteView = UIButton()
    let scannerLogo = UIImageView()
    let scannerTitle = UILabel()
    let scannerSubtitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray(0.08)
        configSearchController()
        self.title = "添加伙伴"
        // Do any additional setup after loading the view.
        self.view.addSubview(profileInfoButton)
        self.view.addSubview(backWhiteView)
        backWhiteView.addSubview(scannerLogo)
        scannerLogo.image = UIImage(named:"scan_icon_small_i")
        backWhiteView.addSubview(scannerTitle)
        scannerTitle.font = UIFont.systemFont(ofSize: 19)
        scannerTitle.textColor = UIColor.gray
        backWhiteView.addSubview(scannerSubtitle)
        scannerTitle.text = "扫一扫"
        scannerSubtitle.font = UIFont.systemFont(ofSize: 14)
        scannerSubtitle.textColor = UIColor.gray
        scannerSubtitle.text = "扫描二维码名片添加伙伴"
        self.backWhiteView.addTarget(self , action: #selector(scannerClick(sender:)), for: UIControlEvents.touchUpInside)
        self.setProfileInfo()
        self.requestApi()
    }
    func requestApi() {
        DDRequestManager.share.getAccountQRCode(type: ApiModel<DDAccountQRCodeModel>.self,success: { (model ) in
            
        }, failure: { (error ) in
            
        }) {
            
        }
    }
    func setProfileInfo()  {
        self.profileInfoButton.frame = CGRect(x: 0, y: self.searchBar.frame.maxY, width: self.view.bounds.width, height: 44)
        self.profileInfoButton.addTarget(self , action:#selector(profileClick(sender:)), for: UIControlEvents.touchUpInside)
        
        let atachment = UIImage(named:"verification_code")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3, width: 22, height: 22)) ?? NSAttributedString(string: "")

        let title = ["我的账号: ","18888888888 "].setColor(colors: [UIColor.gray , UIColor.gray])
        var mutableAttribute = NSMutableAttributedString(attributedString: title)
        mutableAttribute.append(atachment)
        profileInfoButton.setAttributedTitle(mutableAttribute, for: UIControlState.normal)
        self.backWhiteView.backgroundColor = UIColor.white
        self.backWhiteView.frame = CGRect(x: 0, y: self.profileInfoButton.frame.maxY , width: self.view.bounds.width, height: 72)
        let margin : CGFloat = 10
        scannerLogo.frame = CGRect(x: margin, y: margin, width: backWhiteView.bounds.height - margin * 2, height: backWhiteView.bounds.height - margin * 2)
        scannerTitle.frame = CGRect(x: scannerLogo.frame.maxX + margin, y: scannerLogo.frame.minY, width: backWhiteView.bounds.width - (scannerLogo.frame.maxX + margin * 3), height:24)
        
        scannerSubtitle.frame = CGRect(x: scannerLogo.frame.maxX + margin, y: scannerLogo.frame.maxY - 24, width:backWhiteView.bounds.width - (scannerLogo.frame.maxX + margin * 3), height: 24)
        
    }
    @objc func profileClick(sender:UIButton){
        mylog("see qrCode")
    }
    @objc func scannerClick(sender:UIButton){
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
extension DDAddFriendVC :  UISearchBarDelegate , UISearchControllerDelegate {
    func configSearchController()  {
        // 由于其子控件是懒加载模式, 所以找之前先将其显示
        searchBar.placeholder = "姓名/手机号"
        searchBar.backgroundColor = UIColor.clear
        let img = UIImage.ImageWithColor(color: UIColor.clear, frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        searchBar.setBackgroundImage(img , for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        let img1 = UIImage.ImageWithColor(color: UIColor.white, frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        
        searchBar.setSearchFieldBackgroundImage(img1, for: UIControlState.normal)
        searchBar.setShowsCancelButton(false , animated: false )
        // 这个方法来遍历其子视图, 找到cancel按钮
        for subview in searchBar.subviews {
            for subsubview in subview.subviews{
                if let button = subsubview as? UITextField{
                    button.layer.cornerRadius = 9
                    button.layer.masksToBounds = true
//                    button.layer.borderWidth = 1.2
//                    button.layer.borderColor = UIColor.lightGray.cgColor
                }
            }
        }
        
//        self.navigationItem.titleView = self.searchBar
        self.view.addSubview(self.searchBar)
        let margin : CGFloat = 11
        self.searchBar.frame = CGRect(x: margin, y: margin + DDNavigationBarHeight, width: self.view.bounds.width - margin * 2 , height: 38)
        self.searchBar.returnKeyType = UIReturnKeyType.search
        self.searchBar.delegate  = self
        //        self.searchVC.searchBar.barTintColor = UIColor.white
        // It is usually good to set the presentation context.
        //        self.definesPresentationContext = true
        //        tableView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        self.navigationController?.pushViewController(DDUserSearchVC(), animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        mylog("ssss")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        mylog("ssss")
        for subview in searchBar.subviews {
            for subsubview in subview.subviews{
                if let button = subsubview as? UIButton{
                    button.isEnabled = true; //把enabled设置为yes
                    button.isUserInteractionEnabled = true
                    //                    button.state = UIControlState.normal
                }
            }
        }
    }
}

class DDAccountQRCodeModel: Codable {
    var qrcode : String? //通过扫图片获取到一个字符串，此字符串每一项内容用逗号隔开，字符串的内容（用户ID，用户账号，用户手机号，用户头像）    string
    var nickname : String?
    var head_images    :String?
    var mobile : String?
}
