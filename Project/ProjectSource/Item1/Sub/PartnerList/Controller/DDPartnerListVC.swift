//
//  DDPartnerListVC.swift
//  Project
//
//  Created by WY on 2018/1/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerListVC: DDNormalVC , UITextFieldDelegate{
    enum ShowType:String {
        case singleSelection
        case multipleSelection
        case cancle
        case done
    }
    enum ActionType:String {
        case singleSelection
        case multipleSelection
    }
    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 0
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    let searchBox = UITextField.init()
    var multipleSelection : Bool = false
    var showType  = ShowType.multipleSelection
    var actionType = ActionType.singleSelection
    let tipsLabel = UIButton()
//    var users  : [DDUserModel] = {
//        var temp  = [DDUserModel]()
//        for index  in 0...9 {
//            let model = DDUserModel()
////            model.isSelected = index % 2 == 0 ? true : false
//            temp.append(model)
//        }
//        return temp
//    }()
    var apiModel : ApiModel<[DDUserModel]>?
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        self.configTableView()
        requestApi()
    }
    var appointType: DDAppointType = DDAppointType.single
    
    func requestApi() {
        DDRequestManager.share.choosePartnerAndAppoint(type: ApiModel<[DDUserModel]>.self, keyWord: nil) { (model ) in
            self.apiModel = model
//            self.apiModel?.data = nil //////////////
            if self.apiModel?.data?.count ?? 0 <= 0{
                let attributeTitle = ["对不起，您还没有添加伙伴","\n点击添加"].setColor(colors: [UIColor.lightGray , UIColor.blue])
                self.tipsLabel.setAttributedTitle(attributeTitle, for: UIControlState.normal)
                self.tipsLabel.isHidden = true
                self.tipsLabel.addTarget(self , action: #selector(self.performAddFriends), for: UIControlEvents.touchUpInside)
                self.tipsLabel.isHidden = false
                //                GDAlertView.alert("没有找到符合搜索条件的内容。", image: nil , time: 3, complateBlock: nil )
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }else{
                self.tipsLabel.isHidden = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            self.tableView.reloadData()
        }
    }
    final func searchPartnerApi(username:String?) {
        if let pare = username , pare.count > 0{
            DDRequestManager.share.searchPartner(type: ApiModel<[DDUserModel]>.self , username:pare) { (model ) in
                self.apiModel = model
//                self.apiModel?.data = nil //////////////
                let attributeTitle = ["没有符合条件的伙伴"].setColor(colors: [UIColor.lightGray])
                self.tipsLabel.setAttributedTitle(attributeTitle, for: UIControlState.normal)
                if self.apiModel?.data?.count ?? 0 <= 0{
                    self.tipsLabel.removeTarget(self , action: #selector(self.performAddFriends), for: UIControlEvents.touchUpInside)
                    let attributeTitle = ["没有符合条件的伙伴"].setColor(colors: [UIColor.lightGray])
                    self.tipsLabel.setAttributedTitle(attributeTitle, for: UIControlState.normal)
                    self.tipsLabel.isHidden = false
                    //                GDAlertView.alert("没有找到符合搜索条件的内容。", image: nil , time: 3, complateBlock: nil )
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }else{
                    self.tipsLabel.isHidden = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
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
        
        self.view.addSubview(tipsLabel)
        self.tipsLabel.isHidden = true
//        let attributeTitle = ["对不起，您还没有添加伙伴\n","点击添加"].setColor(colors: [UIColor.lightGray , UIColor.blue])
//        tipsLabel.setAttributedTitle(attributeTitle, for: UIControlState.normal)
        tipsLabel.titleLabel?.numberOfLines = 0
        tipsLabel.titleLabel?.textAlignment = .center
//        tipsLabel.addTarget(self , action: #selector(performAddFriends), for: UIControlEvents.touchUpInside)
//        self.tipsLabel.sizeToFit()
        self.tipsLabel.bounds = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 66)
        self.tipsLabel.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
    }
    @objc func performAddFriends(){
        self.navigationController?.pushVC(vcIdentifier: "DDUserSearchVC")
    }
    func configNaviBar() {
        self.title = "邀请伙伴"
        let rightButton = UIBarButtonItem.init(title: "多选", style: UIBarButtonItemStyle.plain, target: self , action: #selector(addBtnClick(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.clear ], for: UIControlState.disabled)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        //        self.jianbian(view: self.navigationController?.navigationBar)
        //        self.navigationController?.navigationBar.layer.addSublayer(<#T##layer: CALayer##CALayer#>)
        
    }
    func configContentToRightButton() {
        switch self.showType {
        case .multipleSelection:
            self.navigationItem.rightBarButtonItem?.title = "多选"
        case .cancle:
            self.navigationItem.rightBarButtonItem?.title = "取消"
        case .done:
            self.navigationItem.rightBarButtonItem?.title = "完成"
        case .singleSelection:
            break
        }
    }
    //    func jianbian(view:UIView?)  {
    //        let colorlayer: CAGradientLayer = CAGradientLayer()
    //        colorlayer.startPoint = CGPoint(x: 0, y: 0.5)
    //        colorlayer.endPoint = CGPoint(x: 1, y: 0.5)
    //        let startColor = UIColor.red.cgColor
    //        let midColor  = UIColor.green.cgColor
    //        let endColor = UIColor.blue.cgColor
    //        colorlayer.colors = [startColor,midColor,endColor]
    //        colorlayer.frame = view?.bounds ?? CGRect.zero
    //        view?.layer.addSublayer(colorlayer)
    //    }
    //textfieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        self.renew()
        return true
    }
    func renew() {
        self.actionType = .singleSelection
        self.navigationItem.rightBarButtonItem?.title = "多选"
        self.showType = .multipleSelection
        self.multipleSelection = false
        self.view.endEditing(true )
        
        for model in apiModel?.data ?? [] {
            model.isSelected = false
        }
        
        
        self.tableView.reloadData()
        
        configContentToRightButton()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            self.view.endEditing(true)
            mylog("perform search ")
            searchPartnerApi(username: textField.text)
            return false
        }
        return true
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
        searchBox.placeholder = "搜索"
        searchBox.returnKeyType = .search
        return tableHeader
    }
}

extension DDPartnerListVC {
    @objc func addBtnClick(sender:UIBarButtonItem?){
       mylog("add click")
        self.view.endEditing(true )
        self.multipleSelection = !self.multipleSelection
        switch self.showType {
        case .multipleSelection:
            self.actionType = .multipleSelection
            self.navigationItem.rightBarButtonItem?.title = checkWheatherNoOneBeSelected() ? "取消" : "完成"
            self.showType = checkWheatherNoOneBeSelected() ? .cancle : .done
        case .cancle:
            self.actionType = .singleSelection
            self.navigationItem.rightBarButtonItem?.title = "多选"
            self.showType = .multipleSelection
            //显示多选
        case .done:
            //跳走
            var selectedPartnerIDs = [String]()
            var selectedAppointIDs = [String]()
            apiModel?.data?.forEach({ (model ) in
                if model.isSelected{
                    if model.status ?? "-1" == "1"{
                        selectedPartnerIDs.append(model.id)
                    }else if model.status ?? "-1" == "2"{
                        selectedAppointIDs.append(model.id)
                    }
                }
            })
            DDShowManager.push(midArr: selectedPartnerIDs, appointmentArr: selectedAppointIDs, currentVC: self, finished: {[weak self] (arr) in
                self?.actionToVC(arr: arr)
                
            })
//            if selectedPartnerIDs.count == 1{
            
//                self.navigationController?.pushVC(vcIdentifier: "DDCreateConventionVC", userInfo: selectedPartnerIDs.first)
//            }else{
//                self.navigationController?.pushVC(vcIdentifier: "DDCreateGroupConventionVC", userInfo: selectedPartnerIDs)
//            }
            //取消选择状态
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.99) {
                
                self.navigationItem.rightBarButtonItem?.title = "多选"
                self.showType = .multipleSelection
                self.actionType = .singleSelection
                self.multipleSelection = false
                
                self.renew()
            }
            
            return
        case .singleSelection://do nothing
            break
        }
        self.tableView.reloadData()
        configContentToRightButton()
    }
    
}
extension DDPartnerListVC : UITableViewDelegate , UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog(indexPath)
        switch self.actionType {

        case .singleSelection:
            mylog("perform once ")
            if let model = self.apiModel?.data?[indexPath.row] , let appointType = model.status{
                if appointType == "1" {
                    let partnerIDs =  [model.id]
//                        self.navigationController?.pushVC(vcIdentifier: "DDCreateConventionVC", userInfo: model)
                    DDShowManager.push(midArr: partnerIDs, appointmentArr: [String](), currentVC: self) { [weak self](arr) in
                        self?.actionToVC(arr: arr)
                    }
                   
                }else if appointType == "2" {
                    let appointIDs =  [model.id]
           
                    DDShowManager.push(midArr: [String]() , appointmentArr: appointIDs, currentVC: self) { [weak self](arr) in
                        self?.actionToVC(arr: arr)
                    }
                }
                
            }
        default:
            mylog("multiple select , action by done button")
        }
    }
    
    func actionToVC(arr: [DDUserModel]) {
        if arr.count > 1 {
            let vc = DDCreateGroupConventionVC()
            vc.appointType.value = self.appointType
            vc.userInfo = arr
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = DDCreateConventionVC()
            vc.appointType.value = self.appointType
            if let model = arr.first {
                vc.userInfo = model
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = apiModel?.data?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPartnerListCell") as? DDPartnerListCell{
            model?.multipleSelection = self.multipleSelection
            cell.model = model
            cell.delegate = self
            return cell
        }else{
            let cell = DDPartnerListCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPartnerListCell")
            model?.multipleSelection = self.multipleSelection
            cell.model = model
            cell.delegate = self
            return cell
        }
    }
}

extension DDPartnerListVC : DDPartnerListCellDelegate{
    
    func didSelectedCell(cell : DDPartnerListCell){
        mylog(cell.model?.isSelected)
        self.showType = checkWheatherNoOneBeSelected() ? .cancle : .done
        self.configContentToRightButton()
    }
    func checkWheatherNoOneBeSelected() -> Bool  {
        if let users = apiModel?.data{
            for user  in users {
                if user.isSelected{return false}
            }
        }else{return false}
        return true
    }
}
import SDWebImage

@objc  protocol DDPartnerListCellDelegate {
    func didSelectedCell(cell : DDPartnerListCell)
}
class DDPartnerListCell : UITableViewCell {
    let selectButton = UIButton()
    let subviewsContainer = UIView()
    let icon  = UIImageView()
    let title = UILabel()
    let leftSideW : CGFloat = 44
    var isFirst = false
    weak var delegate  : DDPartnerListCellDelegate?
    
    var model : DDUserModel? {
        didSet{
            if let imageURL = model?.head_images {
                let url = URL(string: imageURL)
                
                icon.sd_setImage(with: url, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in }
            }
            title.text = model?.nickname
            self.selectButton.isSelected = model?.isSelected ?? false
            
//            if model?.multipleSelection != oldValue?.multipleSelection {
                if (model?.multipleSelection)! {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self.subviewsContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.width + self.leftSideW, height: self.bounds.height)
                    })
                }else{
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self.subviewsContainer.frame = CGRect(x: -(self.leftSideW), y: 0, width: self.bounds.width + self.leftSideW, height: self.bounds.height)
                    })
                }
//            }
            
        }
    }

    let bottomLine = UIView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        self.contentView.backgroundColor = UIColor.randomColor()
        self.contentView.addSubview(subviewsContainer)
        self.subviewsContainer.addSubview(selectButton)
        selectButton.addTarget(self, action:  #selector(selectButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        self.subviewsContainer.addSubview(icon)
        self.subviewsContainer.addSubview(title)
        //        self.contentView.addSubview(subTitle)
        //        self.contentView.addSubview(time)
        self.contentView.addSubview(bottomLine)
        selectButton.setImage(UIImage(named:"btn_icon"), for: UIControlState.normal)
        selectButton.setImage(UIImage(named:"selected_btn_icon"), for: UIControlState.selected)
        title.textColor = UIColor.DDTitleColor
        //        subTitle.textColor = UIColor.SubTextColor
        //        time.textColor = UIColor.SubTextColor
        
        title.font = GDFont.systemFont(ofSize: 17)
        //        subTitle.font = GDFont.systemFont(ofSize: 15)
        //        time.font = GDFont.systemFont(ofSize: 13)
        
        bottomLine.backgroundColor = UIColor.DDLightGray
                icon.image = UIImage(named: "groupchatbackground")
//        icon.image = QRCodeScannerVC.creatQRCode(string: "this qrCode is created by wyf", imageToInsert: UIImage(named: "groupchatbackground"))
        title.text = "姓名"
        //        subTitle.text = "约定名称"
        //        time.text = "约定时间"
    }
    @objc func selectButtonClick(sender:UIButton)  {
        self.model?.isSelected = !(self.model?.isSelected ?? false )
        sender.isSelected = self.model?.isSelected ?? false
        self.delegate?.didSelectedCell(cell: self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirst { return}
        
        let margin : CGFloat = 10
        let bottomLineH : CGFloat = 2
        let iconWH = self.bounds.height - margin * 2 - bottomLineH
       
        let subviewsContainerW = self.bounds.width + leftSideW
        subviewsContainer.frame = CGRect(x: -leftSideW, y: 0, width: subviewsContainerW, height: self.bounds.height)
        selectButton.frame = CGRect(x: 0, y: 0, width: leftSideW, height: self.subviewsContainer.bounds.height)
        icon.frame = CGRect(x: margin + leftSideW, y: margin , width:iconWH, height:iconWH )
        //        time.ddSizeToFit()
        title.ddSizeToFit()
        title.frame = CGRect(x: icon.frame.maxX + margin, y: icon.frame.midY - title.bounds.height/2, width: self.frame.width - margin - icon.frame.maxX - margin , height: title.bounds.height)

        bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
        
        self.isFirst = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DDUserBaseModel: NSObject {
    var isSelected : Bool = false
    var multipleSelection : Bool = false
}
class DDUserModel: DDUserBaseModel , Codable {
    var id = ""//   用户id或群约id
    var nickname  : String? = ""   //用户姓名或群约姓名
    var head_images : String? = ""//    用户头像或群约logo
    ///    标识 1为好友 2为群约
    var status : String?
    var letter : String?
    ///工资。
    var unitPrice: String?
    ///电话
    var phone: String?
    
}

