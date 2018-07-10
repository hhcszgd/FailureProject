//
//  DDUserSearchVC.swift
//  Project
//
//  Created by WY on 2018/1/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit


class MySearchBar: UISearchBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        var textFld : UITextField?
        var btn : UIButton?
        for subview in self.subviews {
            for subsubview in subview.subviews{
                if let button = subsubview as? UIButton{
                   btn = button
                }
            }
        }
        for subview in self.subviews {
            for subsubview in subview.subviews{
                if let textField = subsubview as? UITextField{
                    let center = textField.center
                    let bounds = CGRect(x: 0, y: 0, width: SCREENWIDTH - 108 , height: 30)
                    textField.bounds = bounds
                    textField.center = CGPoint(x: center.x - 30 , y: center.y)
//                    textField.center = center
                    textField.tintColor = UIColor.gray
                    textField.enablesReturnKeyAutomatically = false
                    textFld = textField
                }
            }
        }
        
        if let  textFld = textFld , let btn = btn {
            let center = textFld.center
            textFld.center = CGPoint(x: btn.frame.minX - textFld.bounds.width/2 - 15, y: center.y)
        }
//        self.superview?.bringSubview(toFront: self)
//        self.subviews.first?.isUserInteractionEnabled = false 
    }
}
extension DDUserSearchVC :  UISearchBarDelegate , UISearchControllerDelegate {
    func configSearchController()  {
        // 由于其子控件是懒加载模式, 所以找之前先将其显示
        searchBar.placeholder = "伙伴姓名/手机号"
//        searchBar.setShowsCancelButton(true , animated: false )
        searchBar.showsCancelButton = true
        // 这个方法来遍历其子视图, 找到cancel按钮
        for subview in searchBar.subviews {
            for subsubview in subview.subviews{
                if let button = subsubview as? UIButton{
                    button.setTitle("确定", for: UIControlState.normal)
                    button.setTitle("确定", for: UIControlState.disabled)
                    button.setTitleColor(UIColor.white , for: UIControlState.disabled)
                    button.isUserInteractionEnabled = true
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                }
            }
        }

        self.navigationItem.titleView = self.searchBar
        
        self.searchBar.returnKeyType = UIReturnKeyType.search
        self.searchBar.delegate  = self
        //        self.searchVC.searchBar.barTintColor = UIColor.white
        // It is usually good to set the presentation context.
        self.definesPresentationContext = true
//        tableView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        mylog("ssss")
        self.search()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
            mylog("ssss")
        self.search()
        for subview in searchBar.subviews {//取消点击searchBar的取消按钮时的诡异事件(键盘未弹出时 点击取消弹出键盘 )
            for subsubview in subview.subviews{
                if let button = subsubview as? UIButton{
                    button.isEnabled = true; //把enabled设置为yes
                    button.isUserInteractionEnabled = true
                    //                    button.state = UIControlState.normal
                }
            }
        }
    }
}

class DDUserSearchVC: DDNormalVC {
    var text = ""
    let searchBox = UITextField.init()
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var apiModel  : ApiModel<[DDPartnerInfoModel]>?
    let tipsLabel = UILabel()
    var searchBar : MySearchBar = MySearchBar.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//         self.configNavigationBar()
        configSearchController()
        
        self.configTableView()
        self.searchBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
//            self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        }
    }

    func requestApi(keyWord:String) {
        DDRequestManager.share.searchUser(type: ApiModel<[DDPartnerInfoModel]>.self, username: keyWord) { (model ) in
            self.apiModel = model
            if self.apiModel?.data?.count ?? 0 <= 0{
                self.tipsLabel.isHidden = false
//                GDAlertView.alert("没有找到符合搜索条件的内容。", image: nil , time: 3, complateBlock: nil )
            }else{self.tipsLabel.isHidden = true }
            self.tableView.reloadData()
        }
    }

    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        self.view.addSubview(tableView)
        self.view.addSubview(tipsLabel)
        self.tipsLabel.isHidden = true
        self.tipsLabel.text = "没有找到符合搜索条件的内容"
        self.tipsLabel.sizeToFit()
        self.tipsLabel.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mylog("will will disappear")
        self.searchBar.resignFirstResponder()
    }
    func configNavigationBar()  {
        self.navigationItem.titleView = searchBox
        searchBox.delegate = self
        searchBox.returnKeyType = UIReturnKeyType.search
        searchBox.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 44 * 2, height: 30)
        //        searchBox.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        //        searchBox.borderStyle = UITextBorderStyle.none // UITextBorderStyle.roundedRect
        searchBox.borderStyle =  UITextBorderStyle.roundedRect
        searchBox.tintColor = UIColor.lightGray
        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
        let img = UIImage(named: "search")
        img?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        rightView.setImage(img, for: UIControlState.normal)
        rightView.backgroundColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1)
        //        rightView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        searchBox.rightView = rightView
        searchBox.rightViewMode = .always
        searchBox.placeholder = "伙伴姓名/手机号"
        let searchButton =  UIBarButtonItem.init(title: "搜索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(search))
        searchButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
        searchButton.setTitlePositionAdjustment(UIOffset.init(horizontal: 9, vertical: 0), for: UIBarMetrics.default)
        self.navigationItem.rightBarButtonItem = searchButton
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

extension DDUserSearchVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog("go partner detail page ")
        if let tempModel = self.apiModel?.data?[indexPath.row]{
            self.navigationController?.pushVC(vcIdentifier: "DDPartnerDetailVC", userInfo: ["type":DDPartnerDetailVC.DDPartnerDetailFuncType.addFriend , "id":tempModel.id] )
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellForReturn : DDPartNerCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPartNerCell") as? DDPartNerCell{
            cellForReturn = cell
        }else{
            cellForReturn = DDPartNerCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPartNerCell")
        }
        cellForReturn.model = self.apiModel?.data?[indexPath.row]
        return cellForReturn
    
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let action1 = UITableViewRowAction.init(style: UITableViewRowActionStyle.default, title: "delete") { (action , indexPath) in
            mylog("delete")
        }
        action1.backgroundColor = UIColor.DDThemeColor
        return [action1]
    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        if section == 0  {
//            label.text = "    partner"
//        }else{
//            label.text = "    convention"
//        }
//        label.backgroundColor = UIColor.DDLightGray
//        return label
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
}

extension DDUserSearchVC : DDSearchSessionHeaderDelegate , UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //        mylog("press return key")
        self.search()
        return true
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    func performAction(){
        let vc =  UIAlertController.init(title: "删除全部历史记录", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let action1 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default) { (action ) in
            
        }
        let action2 = UIAlertAction.init(title: "删除", style: UIAlertActionStyle.default) { (ation ) in
            
        }
        vc.addAction(action2)
        vc.addAction(action1)
        self.present(vc , animated: true) {
            
        }
        mylog("perform action")
    }
    @objc func search()  {
        self.searchBar.resignFirstResponder()
        var keyWord = ""
        if let tempKeyWord =  self.searchBar.text, !tempKeyWord.isEmpty{
            keyWord = tempKeyWord
            
        }else{
            if let placeHolderWork =  self.searchBar.placeholder , !placeHolderWork.isEmpty{
                keyWord = placeHolderWork
                
            }else{return}
        }
        self.performSearch(keyWord:keyWord)
    }
//    @objc func search()  {
//        self.searchBox.resignFirstResponder()
//        var keyWord = ""
//        if let tempKeyWord =  self.searchBox.text, !tempKeyWord.isEmpty{
//            keyWord = tempKeyWord
//
//        }else{
//            if let placeHolderWork =  self.searchBox.placeholder , !placeHolderWork.isEmpty{
//                keyWord = placeHolderWork
//
//            }else{return}
//        }
//        self.performSearch(keyWord:keyWord)
//    }
    func performSearch(keyWord:String ){
        self.requestApi(keyWord: keyWord)
//        let searchResultVC = KeywordSearchResultVC.init(keyWord: keyWord)
//        self.navigationController?.pushViewController(searchResultVC, animated: true )
    }
}

class DDPartNerCell: DDTableViewCell {
    let icon  = UIImageView()
    let title = UILabel()
    //    let subTitle = UILabel()
    //    let time = UILabel()
    let bottomLine = UIView()
    //    var para : ( )
    var model : DDPartnerInfoModel?{
        didSet{
            self.title.text = model?.nickname
            self.icon.setImageUrl(url: model?.head_images)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        self.contentView.backgroundColor = UIColor.randomColor()
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        //        self.contentView.addSubview(subTitle)
        //        self.contentView.addSubview(time)
        self.contentView.addSubview(bottomLine)
        
        title.textColor = UIColor.DDTitleColor
        //        subTitle.textColor = UIColor.SubTextColor
        //        time.textColor = UIColor.SubTextColor
        
        title.font = GDFont.systemFont(ofSize: 17)
        //        subTitle.font = GDFont.systemFont(ofSize: 15)
        //        time.font = GDFont.systemFont(ofSize: 13)
        
        bottomLine.backgroundColor = UIColor.DDLightGray
        //        icon.image = UIImage(named: "groupchatbackground")
        //        icon.image = QRCodeScannerVC.creatQRCode(string: "this qrCode is created by wyf", imageToInsert: UIImage(named: "groupchatbackground"))
        //        title.text = "姓名"
        //        subTitle.text = "约定名称"
        //        time.text = "约定时间"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        let bottomLineH : CGFloat = 2
        let iconWH = self.bounds.height - margin * 2 - bottomLineH
        icon.frame = CGRect(x: margin , y: margin , width:iconWH, height:iconWH )
        //        time.ddSizeToFit()
        title.ddSizeToFit()
        //        subTitle.ddSizeToFit()
        //        time.frame = CGRect(x: self.bounds.width - margin - time.bounds.width, y: icon.frame.minY, width: time.bounds.width, height: time.bounds.height)
        title.frame = CGRect(x: icon.frame.maxX + margin, y: icon.frame.midY - title.bounds.height/2, width: self.frame.width - margin - icon.frame.maxX - margin , height: title.bounds.height)
        //        subTitle.frame = CGRect(x: title.frame.minX, y: icon.frame.maxY - subTitle.bounds.height, width: self.bounds.width - margin * 2 - icon.frame.maxX, height: subTitle.bounds.height)
        bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
