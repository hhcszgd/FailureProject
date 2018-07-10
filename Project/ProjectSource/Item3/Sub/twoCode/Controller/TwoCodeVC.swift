//
//  TwoCodeVC.swift
//  Project
//
//  Created by wy on 2017/12/30.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class TwoCodeVC: GDNormalVC {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet var userHeaderImage: UIImageView!
    
    @IBOutlet var userName: UILabel!
    override func gdAddSubViews() {
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "二维码")
        self.userHeaderImage.image = userImagePlace
        self.userName.text = DDAccount.share.nickname
        self.phone.text = DDAccount.share.username
        if let img = DDAccount.share.headImage, img.count > 0 {
            self.userHeaderImage.sd_setImage(with: imgStrConvertToUrl(img))
        }
        
        self.twoCode.layer.borderWidth = 5
        self.twoCode.layer.borderColor = UIColor.colorWithRGB(red: 221, green: 226, blue: 234).cgColor
        
        let paramete = ["token": token]
        let router = Router.get("Mttuserinfo/getQrcode", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: QrcodeModel.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                if let data = model.data, let img = data.qrcode {
                    self.twoCode.sd_setImage(with: imgStrConvertToUrl(img))
                }
                
            }else {
                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        
        
    }
    @IBOutlet var phone: UILabel!
    @IBOutlet var twoCode: UIImageView!
    
    class QrcodeModel: Codable {
        var qrcode: String?
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
