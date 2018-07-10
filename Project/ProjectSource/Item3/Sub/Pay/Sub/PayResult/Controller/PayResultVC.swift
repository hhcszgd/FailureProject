
//
//  PayResultVC.swift
//  Project
//
//  Created by wy on 2018/5/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class PayResultVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "支付成功")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func successPayTap(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    override func popToPreviousVC() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.removeSpecifyVC(PayVC.self)
        
        
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
