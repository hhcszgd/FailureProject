//
//  AccountDetailVC.swift
//  Project
//
//  Created by wy on 2018/1/4.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AccountDetailVC: GDNormalVC {

    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(UINib.init(nibName: "AccountCell", bundle: Bundle.main), forCellReuseIdentifier: "AccountCell")
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "accountDetails")
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("eaeef4")
        // Do any additional setup after loading the view.
    }
    @IBOutlet var bottom: NSLayoutConstraint!
    
    @IBOutlet var top: NSLayoutConstraint!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
    @IBOutlet var btnBottom: NSLayoutConstraint!
    
    
    @IBOutlet var trueBtn: UIButton!
    
    @IBAction func trueAction(_ sender: UIButton) {
    }
    override func gdAddSubViews() {
        
        self.top.constant = DDNavigationBarHeight + 15
        self.bottom.constant = DDTabBarHeight +  40
        self.btnBottom.constant = TabBarHeight + 10
        self.view.layoutIfNeeded()
        
        
        
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
