//
//  DDItem5NavVC.swift
//  hhcszgd
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDItem5NavVC: UINavigationController {
    convenience init(){
        let rootVC = DDItem5VC()
//        let title =  DDLanguageManager.text("tabbar_item5_title")
        let title =  "公开约定"
        rootVC.title = title
//        rootVC.title = "asdfas"
        self.init(rootViewController: rootVC)
        self.tabBarItem.image = UIImage(named:"publicly_agreed_select")
        self.tabBarItem.selectedImage = UIImage(named:"publicly_agreed_selected")
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
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.navigationController?.pushViewController(DDInternalVC(), animated: true )
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
