//
//  AboutWeVC.swift
//  Project
//
//  Created by wy on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AboutWeVC: GDNormalVC {

    @IBOutlet var topTitle: UILabel!
    
    @IBOutlet var versionLabel: UILabel!
    

    @IBOutlet var top: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "一把通")
        self.top.constant = DDNavigationBarHeight + 30
        self.view.layoutIfNeeded()
//        self.topTitle.text = "农民工的讨薪神器\n大小生意的诚信保障"
        var appVersion: String = "1"
        if let infoDic = Bundle.main.infoDictionary {
            if let version = infoDic["CFBundleShortVersionString"] as? String {
                appVersion = version
            }
        }
        self.versionLabel.text = "For Ios \(appVersion) version"
        
        // Do any additional setup after loading the view.
    }
    override func gdAddSubViews() {
        
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
