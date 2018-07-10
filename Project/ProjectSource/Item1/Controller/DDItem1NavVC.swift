//
//  DDItem1NavVC.swift
//  hhcszgd
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDItem1NavVC: DDBaseNavVC {
    convenience init(){
        let rootVC = DDItem1VC()

//        rootVC.title = DDLanguageManager.text("tabbar_item1_title")
                rootVC.title = "首页"
        self.init(rootViewController: rootVC)
        self.navigationBar.shadowImage = UIImage()
        self.tabBarItem.image = UIImage(named:"homepageicons")
        self.tabBarItem.selectedImage = UIImage(named:"homepageicons_selected")
//        self.title = "navTItle"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
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
