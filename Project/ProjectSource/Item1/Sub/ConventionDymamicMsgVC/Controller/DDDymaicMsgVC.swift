//
//  DDDymaicMsgVC.swift
//  Project
//
//  Created by WY on 2018/1/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDDymaicMsgVC: DDNormalVC {
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



extension DDDymaicMsgVC {

    func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x:0 , y : 0 , width : self.view.bounds.width , height : self.view.bounds.height )
    }
}


extension DDDymaicMsgVC  : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        rootNaviVC?.pushViewController(DDConventionVC(), animated: true )
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDDymaicMsgCell") as? DDDymaicMsgCell{
            cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.DDLightGray : UIColor.white
            return cell
        }else{
            let cell = DDDymaicMsgCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDDymaicMsgCell")
            
            cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.DDLightGray : UIColor.white
            return cell
        }
    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
    //        switch editingStyle {
    //        case .delete:
    //            mylog("delete")
    //        default:
    //            break
    //        }
    //    }
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
    //        return UITableViewCellEditingStyle.delete
    //    }
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
    //        let action1 = UITableViewRowAction.init(style: UITableViewRowActionStyle.default, title: "delete") { (action , indexPath) in
    //            mylog("delete")
    //        }
    //        action1.backgroundColor = UIColor.DDThemeColor
    //        return [action1]
    //    }
}
class DDDymaicMsgCell : UITableViewCell {
    let conventionNumTitle = UILabel()
    let conventionNameTitle = UILabel()
    let moneyTitle = UILabel()
    
    
    let conventionNumValue = UILabel()
    let conventionNameValue = UILabel()
    let moneyValue = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        self.contentView.backgroundColor = UIColor.randomColor()
        
        self.contentView.addSubview(conventionNumTitle)
        self.contentView.addSubview(conventionNameTitle)
        self.contentView.addSubview(moneyTitle)
        
        self.contentView.addSubview(conventionNumValue)
        self.contentView.addSubview(conventionNameValue)
        self.contentView.addSubview(moneyValue)
        
        conventionNumTitle.textColor = UIColor.DDTitleColor
        conventionNameTitle.textColor = UIColor.DDTitleColor
        moneyTitle.textColor = UIColor.DDTitleColor
        
        conventionNumValue.textColor = UIColor.DDSubTitleColor
        conventionNameValue.textColor = UIColor.DDSubTitleColor
        moneyValue.textColor = UIColor.DDSubTitleColor
        
        conventionNumTitle.text = "约定号:"
        conventionNameTitle.text = "约定名称:"
        moneyTitle.text = "报酬:"
        
        conventionNumValue.text = "x189912387469817239847"
        conventionNameValue.text = "this is convention name"
        moneyValue.text = "¥1000.00"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        let H = self.bounds.height / 3
        conventionNumTitle.ddSizeToFit()
        conventionNameTitle.ddSizeToFit()
        moneyTitle.ddSizeToFit()
        
        let titleMaxW = max(conventionNumTitle.bounds.width, conventionNameTitle.bounds.width, moneyTitle.bounds.width)
        conventionNumTitle.frame = CGRect(x: margin, y: 0, width: titleMaxW, height: H)
        conventionNameTitle.frame = CGRect(x: margin, y: H, width: titleMaxW, height: H)
        moneyTitle.frame = CGRect(x: margin, y: H * 2, width: titleMaxW, height: H)
        
        let valueW = self.bounds.width - margin * 3 - titleMaxW
        let valueX = moneyTitle.frame.maxX + margin
        
        conventionNumValue.frame = CGRect(x: valueX, y: 0, width: valueW, height: H)
        conventionNameValue.frame = CGRect(x: valueX, y: H, width: valueW, height: H)
        moneyValue.frame = CGRect(x: valueX, y: H * 2, width: valueW, height: H)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
