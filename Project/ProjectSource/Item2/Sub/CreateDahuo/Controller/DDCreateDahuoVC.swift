//
//  DDCreateDahuoVC.swift
//  Project
//
//  Created by WY on 2017/12/25.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCreateDahuoVC: DDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        // Do any additional setup after loading the view.
    }
    func setNavigationBar()  {
        
        self.title = "创建搭伙"
        self.navigationItem.titleView?.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        let rightBar = UIBarButtonItem.init(title: "提交", style: UIBarButtonItemStyle.plain, target: self, action: #selector(commit))
        rightBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBar
    }
    @objc func commit()  {
    mylog("sadfasd")
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
