//
//  DDConventionTableHeader.swift
//  Project
//
//  Created by WY on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDConventionTableHeaderNew: UIView  {
    let conventionDetailLabel = UILabel()
    let subtitleLabel = UILabel()
    
    ///(1:单，2：群)
    var yue_type : String?
    var model : ApiModel<DDAppointDetailModel>?{
        didSet{
            if let userType = model?.data?.user_type{
                if userType == "1"{//收款方
                    if let status = model?.data?.status.or_st{
                        var statusStr = "未知状态"
                        if status == "0"{
                            statusStr = "待付款"
                        }else if status == "1"{
                            statusStr = "招人中"
                        }else if status == "2"{
                            statusStr = "约定进行中"
                            setSubtitleToMoneyChanged()
                        }else if status == "3"{
                            statusStr = "进行中-有协商"
                            setSubtitleToMoneyChanged()
                        }else if status == "5"{
                            statusStr = "已完成"
                            setSubtitleToConsult()
                        }else if status == "7"{
                            statusStr = "已失效"
                        }
                        if status == "3"{
                            conventionDetailLabel.text =  "进行中"
                        }else{
                            conventionDetailLabel.text = statusStr
                        }
                    }
                }else if userType == "2"{//付款方
                    
                    if yue_type ?? "" == "1" {//单人
                        if let status = model?.data?.status.or_st{
                            var statusStr = "未知状态"
                            if status == "0"{
                                statusStr = "待付款"
                            }else if status == "1"{
                                statusStr = "招人中"
                            }else if status == "2"{
                                statusStr = "约定进行中"
                                setSubtitleToMoneyChanged()
                            }else if status == "3"{
                                statusStr = "进行中-有协商"
                                setSubtitleToMoneyChanged()
                            }else if status == "5"{
                                statusStr = "已完成"
                                setSubtitleToConsult()
                            }else if status == "7"{
                                statusStr = "已失效"
                            }
                            if status == "3"{
                                conventionDetailLabel.text =  "进行中"
                            }else{
                                conventionDetailLabel.text = statusStr
                            }
                        }
                    }else{//多人
                        if let status = model?.data?.status.or_st{
                            var statusStr = "未知状态"
                            
                            if status == "0"{
                                statusStr = "待付款"
                            }else if status == "1"{
                                statusStr = "进行中"
                            }else if status == "-1"{
                                statusStr = "已完成"
                            }else if status == "7"{
                                statusStr = "已失效"
                            }
                            conventionDetailLabel.text = statusStr
                        }
                    }
                    
//                    if let status = model?.data?.status.or_jf{
//                        var statusStr = ""
//                        if status == "0"{
////                            statusStr = "无纠纷"
//                        }else if status == "1"{
//                            statusStr = "有纠纷"
//                            subtitleLabel.text = statusStr
//                        }
//                    }
                }
            }
            
          
//            if yue_type ?? "" == "1" {//单人
//                if let status = model?.data?.status.or_jf{
//                    var statusStr = ""
//                    if status == "0"{
//                        //                            statusStr = "无纠纷"
//                    }else if status == "1"{
//                        statusStr = "有协商"
//                        subtitleLabel.text = statusStr
//                    }
//                }
//                if let status = model?.data?.status.or_xg{
//                    var statusStr = ""
//                    if status == "0"{
//                        //                    statusStr = "金额无修改"
//                    }else if status == "1"{
//                        statusStr = "金额有修改"
//                        subtitleLabel.text = statusStr
//                    }
//                }
//
//            }
            

            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    func setSubtitleToConsult(){
        if yue_type ?? "" == "1" {//单人
            if let status = model?.data?.status.or_jf{
                var statusStr = ""
                if status == "0"{
                    //                            statusStr = "无纠纷"
                }else if status == "1"{
                    statusStr = "有协商"
                    subtitleLabel.text = statusStr
                }
            }
            
        }
        
    }
    
    func setSubtitleToMoneyChanged(){
        if yue_type ?? "" == "1" {//单人
            
            if let status = model?.data?.status.or_xg{
                var statusStr = ""
                if status == "0"{
                    //                    statusStr = "金额无修改"
                }else if status == "1"{
                    statusStr = "报酬有修改"
                    subtitleLabel.text = statusStr
                }
            }
            if let status = model?.data?.status.or_jf{
                var statusStr = ""
                if status == "0"{
                    //                            statusStr = "无纠纷"
                }else if status == "1"{
                    statusStr = "有协商"
                    subtitleLabel.text = statusStr
                }
            }
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(conventionDetailLabel)
        self.addSubview(subtitleLabel)
//        conventionDetailLabel.text = "约定详情"
        conventionDetailLabel.textColor = UIColor.DDThemeColor
        subtitleLabel.textColor = UIColor.orange
        conventionDetailLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        conventionDetailLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        conventionDetailLabel.frame = CGRect(x: DDConventionVC.conventionVCMargin , y: 0, width: conventionDetailLabel.bounds.width, height: self.bounds.height )
        subtitleLabel.frame = CGRect(x: conventionDetailLabel.frame.maxX + 10, y: 0, width: subtitleLabel.bounds.width, height: self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








class DDConventionTableHeader: UIView  {
    let conventionDetailLabel = UILabel()
    let container = UIView()
    let conventionNameLabel = UILabel()
    let conventionValueLabel = UILabel()
    let bottomLine = UIView()
    //    var model : (title :String,value : String , type : String)?{
    //        didSet{
    //            conventionDetailLabel.text = model?.type
    //            conventionNameLabel.text = model?.title
    //            conventionValueLabel.text = model?.value
    //            self.layoutIfNeeded()
    //        }
    //    }
    var model : ApiModel<DDAppointDetailModel>?{
        didSet{
            conventionDetailLabel.text = model?.data?.status.or_jf
            conventionNameLabel.text = model?.data?.status.or_jf
            conventionValueLabel.text = model?.data?.status.or_jf
            self.layoutIfNeeded()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(conventionDetailLabel)
        //        conventionDetailLabel.text = "约定详情"
        conventionDetailLabel.textColor = UIColor.DDThemeColor
        self.addSubview(container)
        self.container.addSubview(conventionNameLabel)
        self.container.addSubview(conventionValueLabel)
        container.backgroundColor = UIColor.white
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = .clear
        
        conventionNameLabel.textColor = UIColor.DDTitleColor
        conventionValueLabel.textColor = UIColor.DDSubTitleColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 20
        let botttomH : CGFloat = 2
        conventionDetailLabel.frame = CGRect(x: DDConventionVC.conventionVCMargin , y: 0, width: self.bounds.width - DDConventionVC.conventionVCMargin * 2, height: (self.bounds.height - botttomH)/2)
        container.frame = CGRect(x: DDConventionVC.conventionVCMargin, y: (self.bounds.height - botttomH)/2, width: self.bounds.width - DDConventionVC.conventionVCMargin * 2, height: (self.bounds.height - botttomH)/2)
        conventionNameLabel.ddSizeToFit()
        conventionNameLabel.frame = CGRect(x: margin, y: 0, width: conventionNameLabel.bounds.width, height: (self.bounds.height - botttomH)/2)
        
        conventionValueLabel.frame = CGRect(x: conventionNameLabel.frame.maxX  + margin , y: 0, width: container.bounds.width - margin - conventionNameLabel.bounds.width, height: (self.bounds.height - botttomH)/2)
        
        bottomLine.frame = CGRect(x: DDConventionVC.conventionVCMargin, y: self.bounds.height - botttomH, width: self.bounds.width - DDConventionVC.conventionVCMargin*2, height: botttomH)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

