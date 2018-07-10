//
//  BalanceVC.swift
//  Project
//
//  Created by wy on 2017/12/30.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class BalanceVC: GDNormalVC {
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var promptTop: NSLayoutConstraint!
    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var moneyLabel: UILabel!
    @IBOutlet var trueBtn: UIButton!
    @IBOutlet var withdrawals: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func trueAction(_ sender: UIButton) {
    }
    @IBAction func withdrawals(_ sender: UIButton) {
    }
    @IBAction func reacargeAction(_ sender: UIButton) {
    }
    override func gdAddSubViews() {
        self.imageHeightConstraint.constant = (CGFloat(400) / CGFloat(750)) * SCREENWIDTH
        self.promptTop.constant = DDNavigationBarHeight + 30
        self.view.layoutIfNeeded()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "balance")
        self.promptLabel.text = DDLanguageManager.text("balance")
        self.trueBtn.setTitle(DDLanguageManager.text("trueBtn"), for: .normal)
        self.naviBar.backgroundColor = UIColor.clear
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
