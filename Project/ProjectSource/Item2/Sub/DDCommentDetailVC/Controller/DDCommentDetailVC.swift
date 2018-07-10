//
//  DDCommentDetailVC.swift
//  Project
//
//  Created by WY on 2017/12/24.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation
class DDCommentDetailVC: DDNoNavibarVC {
    var commentID = ""
    var pageNum : Int  = 0
    let backBtn = UIButton.init(frame: CGRect.zero)
    let titleLbl = UILabel.init(frame: CGRect.zero)
    let tableHeader = CommentDetailTableHeader.init(frame: CGRect.zero)
    var replyMembers : [ReplyMember] = [ReplyMember]()
 
    convenience init(_ commentID:String){
        self.init()
        self.commentID = commentID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        configTableView()
        // Do any additional setup after loading the view.
        requestCommentDetail()
    }
    
    func requestCommentDetail() {
        DDRequestManager.share.commentDetail(commentID: "1" , true )?.responseJSON(completionHandler: { (response ) in
            let jsonDecoder = JSONDecoder.init()
            do{
                let commentApiModel = try jsonDecoder.decode(DDCommentDetailApiModel.self , from: response.data ?? Data())
                mylog(commentApiModel)
                if let commentModel = commentApiModel.data.first{
                    self.tableHeader.model1 = commentModel
                    let H = CommentDetailTableHeader.caculateCellHeight(model: commentModel)
                    let header = CommentDetailTableHeader.init(frame:  CGRect(x: 0, y: 0, width: SCREENWIDTH, height: H))
                    header.model1 = commentModel
                    self.tableView?.tableHeaderView = header
                }
                self.requestCommentReplyList()
            }catch{
                mylog(error)
            }
        })
    }
    func requestCommentReplyList() {
        DDRequestManager.share.commentReplyList(commentID: "1" , true )?.responseJSON(completionHandler: { (response ) in
            let jsonDecoder = JSONDecoder.init()
            do{
                let commentListApiModel = try jsonDecoder.decode(CommentListApiModel.self , from: response.data ?? Data())
                
                if let memberList = commentListApiModel.data{
                    self.replyMembers.append(contentsOf: memberList)
                    
                }
                mylog(commentListApiModel)
                self.tableView?.reloadData()
            }catch{
                mylog(error)
            }
        })
    }
    @objc func refresh()  {
        self.tableView?.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
    }
    @objc func loadMore()  {
        self.pageNum += 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
///ui
extension DDCommentDetailVC{
    func configNaviBar() {
        self.naviBar.addSubview(backBtn)
        self.naviBar.addSubview(titleLbl)
        backBtn.frame = CGRect(x: 10, y: self.naviBar.height - 44, width: 44, height: 44)
        backBtn.setImage(UIImage(named: "back_icon"), for: UIControlState.normal)
        backBtn.addTarget(self , action: #selector(goback), for: UIControlEvents.touchUpInside)
        titleLbl.frame = CGRect(x: backBtn.frame.maxX , y: backBtn.frame.origin.y, width: naviBar.bounds.width - backBtn.frame.maxX  * 2, height: 44)
        titleLbl.textColor = UIColor.white
    }
    func configTableView() {
        
        self.tableView = UITableView.init(frame: CGRect(x: 0, y: DDNavigationBarHeight, width:  self.view.bounds.width, height:  self.view.bounds.height - DDNavigationBarHeight - 44), style: UITableViewStyle.grouped)
        self.view.addSubview(tableView!)
        tableView?.backgroundColor = UIColor.white
        self.tableView?.estimatedRowHeight = 0;
        self.tableView?.estimatedSectionHeaderHeight = 0;
        self.tableView?.estimatedSectionFooterHeight = 0;
        self.tableView?.separatorStyle = .none
        self.tableView?.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        self.tableView?.gdRefreshControl = GDRefreshControl.init(target: self , selector: #selector(refresh))
        tableView?.delegate = self
        tableView?.dataSource = self
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        tableHeader.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH , height: SCREENWIDTH * 1.1 )
//        self.tableView?.tableHeaderView = tableHeader
    }
    
}
/// actions
extension DDCommentDetailVC{
    @objc func goback()  {
        self.popToPreviousVC()
    }
}

extension DDCommentDetailVC :UITableViewDataSource , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return replyMembers.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyMembers[section].reply?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell  = tableView.dequeueReusableCell(withIdentifier: "CommentDetailCell") as? CommentDetailCell {
            if let cellModel = replyMembers[indexPath.section].reply?[indexPath.row]{
                    cell.model = cellModel
            }
            
            return cell
        }else{
            let cell =   CommentDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "CommentDetailCell")
            if let cellModel = replyMembers[indexPath.section].reply?[indexPath.row]{
                cell.model = cellModel
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let model = self.replyMembers[indexPath.section].reply?[indexPath.row]{
            return CommentDetailCell.rowHeight(model: model)
        }
        return 30
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let member = self.replyMembers[section]
        return CommentDetailSectionHeader.heightForHeader(model: member)
//        return 64
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentDetailSectionFooter") as? CommentDetailSectionFooter{
//            footer.contentView.backgroundColor = UIColor.randomColor()
            return footer
        }else{
            let footer = CommentDetailSectionFooter.init(reuseIdentifier: "CommentDetailSectionFooter")
//            footer.contentView.backgroundColor = UIColor.randomColor()
            return footer
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentDetailSectionHeader") as? CommentDetailSectionHeader{
//            header.contentView.backgroundColor = UIColor.randomColor()
            header.model = replyMembers[section]
            return header
        }else{
            let header = CommentDetailSectionHeader.init(reuseIdentifier: "CommentDetailSectionHeader")
//            header.contentView.backgroundColor = UIColor.randomColor()
            header.model = replyMembers[section]
            return header
        }
    }
}

    
    
    
    
    
    
    
    
    
    
    
    

import ContactsUI
import Contacts
extension DDCommentDetailVC : CNContactPickerDelegate {
    func shouContactVC() {
        let contact : CNContactPickerViewController = CNContactPickerViewController.init()
        contact.delegate  = self 
        self.navigationController?.present(contact, animated: true , completion: nil )
    }
    /*!
     * @abstract    Invoked when the picker is closed.
     * @discussion  The picker will be dismissed automatically after a contact or property is picked.
     */
    func contactPickerDidCancel(_ picker: CNContactPickerViewController){
        
    }
    
    
    /*!
     * @abstract    Singular delegate methods.
     * @discussion  These delegate methods will be invoked when the user selects a single contact or property.
     */
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact){
//        mylog(contact)
//    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty){
//
//    }
    
    
    /*!
     * @abstract    Plural delegate methods.
     * @discussion  These delegate methods will be invoked when the user is done selecting multiple contacts or properties.
     *              Implementing one of these methods will configure the picker for multi-selection.
     */
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]){
        
        mylog(contacts.first?.phoneNumbers)
    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelectContactProperties contactProperties: [CNContactProperty]){
//
//    }
}
