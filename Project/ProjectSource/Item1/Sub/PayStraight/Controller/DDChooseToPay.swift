//
//  DDChooseToPay.swift
//  Project
//
//  Created by WY on 2018/4/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
class DDChooseToPay: DDItem2VC  {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath){
        self.navigationController?.pushVC(vcIdentifier: "DDPayStraightVC", userInfo: self.model?.data?[indexPath.section].info?[indexPath.row].id)
        mylog(indexPath)
    }
}
/*
class DDChooseToPay: DDNormalVC , UITextFieldDelegate {

    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 0
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    let searchBox = UITextField.init()
    var multipleSelection : Bool = false
    var users  : [DDUserModel] = {
        var temp  = [DDUserModel]()
        for index  in 0...3 {
            let model = DDUserModel()
            //            model.isSelected = index % 2 == 0 ? true : false
            temp.append(model)
        }
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        self.configTableView()
        requestApi()
    }
    func requestApi() {
        DDRequestManager.share.getPartnerList(type: ApiModel<String >.self) { (model ) in
            dump(model)
        }
    }
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.configTableHeaderView()
        
    }
    func configNaviBar() {
        self.title = "伙伴"
    }
    //textfieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
//        self.navigationController?.pushViewController(DDUserSearchVC(), animated: true)
        mylog("search in current page without jump")
        return false
    }
    
    
    @objc func loadMore()  {
        self.pageNum += 1
        
    }
    @objc func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pageNum = 0
            
        }
    }
    
    func configTableHeaderView() -> UIView{
        let tableHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width , height: 64))
        let searchBoxEdgeInset = UIEdgeInsetsMake(15, 10, 15, 10)
        searchBox.delegate =  self //UITextFieldDelegate
        tableHeader.addSubview(searchBox)
        searchBox.frame = CGRect(x: searchBoxEdgeInset.left, y: searchBoxEdgeInset.top, width: UIScreen.main.bounds.width - searchBoxEdgeInset.left - searchBoxEdgeInset.right, height: tableHeader.bounds.height - searchBoxEdgeInset.top - searchBoxEdgeInset.bottom)
        
        tableHeader.backgroundColor = UIColor.colorWithHexStringSwift("#eeeeee")
        searchBox.backgroundColor = UIColor.white
        searchBox.borderStyle = UITextBorderStyle.roundedRect
        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
        rightView.setImage(UIImage(named: "search"), for: UIControlState.normal)
        rightView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        searchBox.rightView = rightView
        searchBox.rightViewMode = .always
        searchBox.placeholder = "search"
        return tableHeader
    }
}

extension DDChooseToPay : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushVC(vcIdentifier: "DDPayStraightVC", userInfo: "2")
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titles =  ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
        let label = UILabel()
        label.text = "  " +  titles[section]
        label.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        return label
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = users[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPartnerListInternalCell") as? DDPartnerListInternalCell{
            model.multipleSelection = self.multipleSelection
            cell.model = model
            return cell
        }else{
            let cell = DDPartnerListInternalCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPartnerListInternalCell")
            model.multipleSelection = self.multipleSelection
            cell.model = model
            return cell
        }
    }
}
import SDWebImage
extension DDChooseToPay{
    class DDPartnerListInternalCell : UITableViewCell {
        let icon  = UIImageView()
        let title = UILabel()
        var model : DDUserModel? {
            didSet{
                icon.setImageUrl(url: model?.imageUrl)
                title.text = model?.name
            }
        }
        let bottomLine = UIView()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.contentView.addSubview(icon)
            self.contentView.addSubview(title)
            self.contentView.addSubview(bottomLine)
            title.textColor = UIColor.DDTitleColor
            title.font = GDFont.systemFont(ofSize: 17)
            bottomLine.backgroundColor = UIColor.DDLightGray
                    icon.image = UIImage(named: "groupchatbackground")
//            icon.image = QRCodeScannerVC.creatQRCode(string: "this qrCode is created by wyf", imageToInsert: UIImage(named: "groupchatbackground"))
            title.text = "姓名"
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let bottomLineH : CGFloat = 2
            let iconWH = self.bounds.height - margin * 2 - bottomLineH
            icon.frame = CGRect(x: margin , y: margin , width:iconWH, height:iconWH )
            title.ddSizeToFit()
            title.frame = CGRect(x: icon.frame.maxX + margin, y: icon.frame.midY - title.bounds.height/2, width: self.frame.width - margin - icon.frame.maxX - margin , height: title.bounds.height)
            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
*/
