//
//  DDShopVC.swift
//  Project
//
//  Created by WY on 2017/12/15.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation

import Alamofire
class DDItem2VC: DDNormalVC , UITextFieldDelegate{
//    enum ShowType:String {
//        case multipleSelection
//        case cancle
//        case done
//    }
    var model :  ApiModel<[DDPartnerGroupModel]>?
    var searchResultModel : ApiModel<[DDPartnerModel]>?
    var filteredArr : [DDPartnerGroupModel]?
    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 0
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
    let searchBox = UITextField.init()
//    var multipleSelection : Bool = false
//    var showType  = ShowType.multipleSelection
//    var users  : [DDUserModel] = {
//        var temp  = [DDUserModel]()
//        for index  in 0...3 {
//            let model = DDUserModel()
//            model.isSelected = index % 2 == 0 ? true : false
//            temp.append(model)
//        }
//        return temp
//    }()
//    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configNaviBar()
        self.configTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestApi()
        DDNotification.postNetworkChanged(networkStatus: (oldStatus: true, newStatus: true))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    final func requestApi() {
        DDRequestManager.share.getPartnerListNew(type: ApiModel<[DDPartnerGroupModel]>.self, success: { (model ) in
            self.model = model
            self.filteredArr = model.data
            self.searchResultModel = nil
            if model.data?.count ?? 0 <= 0 {
                DDErrorView(superView: self.view , error: DDError.noExpectData("暂无好友")).automaticRemoveAfterActionHandle = {
                    self.requestApi()
                }
            }
            self.tableView.gdRefreshControl?.endRefresh()
            self.tableView.reloadData()
        }, failure: { (error ) in
            DDErrorView(superView: self.view , error: error).automaticRemoveAfterActionHandle = {
                self.requestApi()
            }
        }) {
            
        }
        
//        DDRequestManager.share.getPartnerList(type: ApiModel<[DDPartnerGroupModel]>.self) { (model ) in
//            self.model = model
//            self.filteredArr = model?.data
//            self.searchResultModel = nil
//            if model?.data?.count ?? 0 <= 0 {
//                GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock: nil )
//            }
//            self.tableView.gdRefreshControl?.endRefresh()
//            self.tableView.reloadData()
//        }
    }
    final func searchPartnerApi(username:String?) {
        if let pare = username , pare.count > 0{
            DDRequestManager.share.searchPartner(type: ApiModel<[DDPartnerModel]>.self , username:pare) { (model ) in
                self.searchResultModel = model
//                self.filteredArr = model?.data
                if model?.data?.count ?? 0 <= 0 {
                    GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock: nil )
                }
                self.tableView.gdRefreshControl?.endRefresh()
                self.tableView.reloadData()
            }
        }else{
            self.requestApi()
        }
    }
    
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.configTableHeaderView()
        tableView.gdRefreshControl = GDRefreshControl.init(target: self , selector: #selector(performRefresh))
        tableView.gdRefreshControl?.refreshHeight = 40 
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.navigationController?.automaticallyAdjustsScrollViewInsets = false 
        }
    }
    @objc func performRefresh(){
        self.pageNum = 0
        searchPartnerApi(username: self.searchBox.text)
    }
    func configNaviBar() {
        let searchButton = UIBarButtonItem.init(image: UIImage(named:"addpartnericons"), style: UIBarButtonItemStyle.plain, target: self , action: #selector(addPartnerAction(sender:)))
        searchButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
        searchButton.setTitlePositionAdjustment(UIOffset.init(horizontal: 9, vertical: 0), for: UIBarMetrics.default)
        self.navigationItem.rightBarButtonItem = searchButton
    }
    @objc func addPartnerAction(sender:UIBarButtonItem)  {
        mylog("add friend")
        self.navigationController?.pushVC(vcIdentifier: "DDAddFriendVC")
    }
    //textfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            self.view.endEditing(true)
            mylog("perform search ")
//            self.filterWithKeyWord(keyWord: textField.text)
            self.searchPartnerApi(username: textField.text)
            return false
        }
        return true
    }
    
    func filterWithKeyWord(keyWord:String?) {
        if let keyword = keyWord , keyword.count > 0{
            var filteredArr = [DDPartnerGroupModel]()
            self.model?.data?.forEach({ (groupModel ) in
                let tempGroupModel = groupModel.mutableCopy(with: nil) as? DDPartnerGroupModel
                groupModel.info = groupModel.info?.map({ (partnerModel) -> DDPartnerModel in
                    return partnerModel.mutableCopy(with: nil) as! DDPartnerModel
                })
                tempGroupModel?.info = tempGroupModel?.info?.filter({ (partnerModel ) -> Bool in
                    return partnerModel.nickname.contains(keyword)
                })
                
                if tempGroupModel?.info?.count ?? 0 > 0 {
                    filteredArr.append(tempGroupModel!)
                }
            })
            self.filteredArr = filteredArr
        }else{
            self.filteredArr = self.model?.data
        }
        self.tableView.reloadData()
    }
    
    @objc func loadMore()  {
        self.pageNum += 1
        
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
        searchBox.placeholder = "搜索"
        searchBox.returnKeyType = .search
        return tableHeader
    }
}

extension DDItem2VC : UITableViewDelegate , UITableViewDataSource {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tempModel = filteredArr?[indexPath.section].info?[indexPath.row]{
            self.navigationController?.pushVC(vcIdentifier: "DDPartnerDetailVC", userInfo: ["type":DDPartnerDetailVC.DDPartnerDetailFuncType.friendDetail , "id":tempModel.id] )
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
         if self.searchResultModel == nil {
            return 30
         }else{
            return 0.0001
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.001
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.searchResultModel == nil {

            var titles  = [String]()
            filteredArr?.forEach({ (model ) in
                titles.append(model.letter)
            })
            return titles
        }else{
            return nil
        }
//        return ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 9
        if self.searchResultModel == nil {
            return filteredArr?.count ?? 0
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .white
        if self.searchResultModel == nil {
            if let title = filteredArr?[section].letter{
                label.text = "  " +  title
            }
            label.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30)
            return label
            
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchResultModel == nil {
            return filteredArr?[section].info?.count ?? 0
        }else{
            return self.searchResultModel?.data?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = users[indexPath.row]
        var cellReturn : DDPartnerListInternalCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPartnerListInternalCell") as? DDPartnerListInternalCell{
//            model.multipleSelection = self.multipleSelection
            cellReturn =  cell
        }else{
            cellReturn = DDPartnerListInternalCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPartnerListInternalCell")
//            model.multipleSelection = self.multipleSelection
//            cell.model = model
//            return cell
        }
        
        if self.searchResultModel == nil {
            if let partnerModel = filteredArr?[indexPath.section].info?[indexPath.row]{
                //            partnerModel.multipleSelection = self.multipleSelection
                cellReturn.model = partnerModel
            }
            
        }else{
            if let partnerModel = searchResultModel?.data?[indexPath.row]{
                //            partnerModel.multipleSelection = self.multipleSelection
                cellReturn.model = partnerModel
            }
        }
        
        
        return cellReturn
    }
}
import SDWebImage
extension DDItem2VC{
    class DDPartnerListInternalCell : UITableViewCell {
        let icon  = UIImageView()
        let title = UILabel()
        var model : DDPartnerModel? {
            didSet{
                icon.setImageUrl(url: model?.head_images)
//                if let imageURL = model?.head_images {
//                    let url = URL(string: imageURL)
//
//                    icon.sd_setImage(with: url, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in }
//                }
                title.text = model?.nickname
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
            //        icon.image = UIImage(named: "groupchatbackground")
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
//extension DDItem2VC : DDPartnerListCellDelegate{
//
//    func didSelectedCell(cell : DDPartnerListCell){
//        mylog(cell.model?.isSelected)
//        self.showType = checkWheatherNoOneBeSelected() ? .cancle : .done
//        self.configContentToRightButton()
//    }
//    func checkWheatherNoOneBeSelected() -> Bool  {
//        for user  in self.users {
//            if user.isSelected{return false}
//        }
//        return true
//    }
//}
//import SDWebImage

//@objc  protocol DDPartnerListCellDelegate {
//    func didSelectedCell(cell : DDPartnerListCell)
//}

//
//class DDUserBaseModel: NSObject {
//    var isSelected : Bool = false
//    var multipleSelection : Bool = false
//}
//class DDUserModel: DDUserBaseModel , Codable {
//    var name  = "姓名"
//    var imageUrl = "http://ozstzd6mp.bkt.gdipper.com/e8afacc4aff1b456d58a25af234096d7.jpg"
//}

