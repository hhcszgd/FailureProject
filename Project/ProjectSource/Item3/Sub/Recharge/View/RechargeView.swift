//
//  RechargeView.swift
//  Project
//
//  Created by 张凯强 on 2018/5/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class RechargeView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.containerView = Bundle.main.loadNibNamed("RechargeView", owner: self, options: nil)?.last as! UIView
        self.addSubview(self.containerView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    var containerView: UIView!
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
