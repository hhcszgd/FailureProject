//
//  DDPayPartnersDetailView.swift
//  Project
//
//  Created by 金曼立 on 2018/5/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDPayPartnersDetailView: UIView {
    
    var btnCallBack:((UIButton) -> ())?
    var num : String?  // 1 单期  2 多期
    var yue_type : String? // 1 单约  2 群约
    
    let headerViewBg = UIView()
    let appointName = UILabel.configlabel(font: UIFont.systemFont(ofSize: 16), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "")
    let money = UILabel.configlabel(font: UIFont.systemFont(ofSize: 16), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "")
//    let iconBgView = UIView()
//    let icon = UIImageView()
//    let name = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "姓名：")
    let indexBg = UIView()
    let indexLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 16), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "")
    let leftBtn = UIImageView()
    let rightBtn = UIImageView()
    
    let tableView = UITableView()
    var collectionView : UICollectionView?
    let flowLayout = UICollectionViewFlowLayout()
    
    let bottomView = UIView()
    let lineView = UIView()
    let titleLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "终止约定报酬详情：")
    let originMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: color11, text: "原定报酬：")
    let originMoneyNum = UILabel()
    let backMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: color11, text: "退款报酬：")
    let backMoneyNum = UILabel()
    let payMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: color11, text: "实际报酬：")
    let payMoneyNum = UILabel()
    
    var payDetailModel : DDPayDetailModel? = DDPayDetailModel() {
        didSet{
            appointName.text = payDetailModel?.name
            money.text = payDetailModel?.price_all
            if payDetailModel?.stop == "1" {
                bottomView.isHidden = false
                originMoneyNum.attributedText = self.attributedString(number: payDetailModel?.stop_price ?? "", string: "元")
                backMoneyNum.attributedText = self.attributedString(number: payDetailModel?.stop_rest_price ?? "", string: "元")
                payMoneyNum.attributedText = self.attributedString(number: payDetailModel?.stop_pay_price ?? "", string: "元")
            } else {
                bottomView.isHidden = true
                tableView.snp.remakeConstraints { (make) in
                    make.top.equalTo(headerViewBg.snp.bottom)
                    make.left.right.equalTo(headerViewBg)
                    make.bottom.equalToSuperview()
                }
            }
            if yue_type == "2" {
//                iconBgView.isHidden = true
                if num ?? "" == "1" {
                    // 多期 单人
                    indexBg.isHidden = true
                    headerViewBg.snp.remakeConstraints { (make) in
                        make.left.top.right.equalToSuperview()
                        make.height.equalTo(80)
                    }
                    money.snp.remakeConstraints { (make) in
                        make.top.equalTo(appointName.snp.bottom).offset(14)
                        make.left.right.equalTo(appointName)
                        make.bottom.equalTo(headerViewBg).offset(-15)
                    }
                } else {
                    // 多期 多人
                    tableView.isHidden = true
                    indexBg.isHidden = false
                    indexLabel.text = (payDetailModel?.num ?? "") + "/" + (payDetailModel?.num_all ?? "")
                    if payDetailModel?.num == "1" {
                        leftBtn.isHidden = true
                        rightBtn.isHidden = false
                    } else if payDetailModel?.num == payDetailModel?.num_all {
                        leftBtn.isHidden = false
                        rightBtn.isHidden = true
                    } else {
                        leftBtn.isHidden = false
                        rightBtn.isHidden = false
                    }
                    flowLayout.itemSize = CGSize(width: SCREENWIDTH, height: self.frame.size.height - 100)
                    headerViewBg.snp.remakeConstraints { (make) in
                        make.left.top.right.equalToSuperview()
                        make.height.equalTo(100)
                    }
                    indexBg.snp.makeConstraints { (make) in
                        make.top.equalTo(money.snp.bottom).offset(10)
                        make.left.right.equalToSuperview()
                        make.bottom.equalToSuperview()
                    }
                    collectionView?.snp.makeConstraints { (make) in
                        make.top.equalTo(headerViewBg.snp.bottom)
                        make.left.right.equalTo(headerViewBg)
                        make.bottom.equalToSuperview()
                    }
                }
            } else {
                // 单期
                headerViewBg.snp.remakeConstraints { (make) in
                    make.left.top.right.equalToSuperview()
                    make.height.equalTo(80)
                }
//                headerViewBg.snp.remakeConstraints { (make) in
//                    make.left.top.right.equalToSuperview()
//                    make.height.equalTo(200)
//                }
//                icon.setImageUrl(url: payDetailModel?.item?[0].blogo)
//                let nameStr = payDetailModel?.item?[0].bname ?? ""
//                let phoneStr = payDetailModel?.item?[0].bphone ?? ""
//                name.text = nameStr + "(" + phoneStr + ")"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        indexBg.isHidden = true
        leftBtn.image = UIImage(named: "left")
        rightBtn.image = UIImage(named: "right")
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect.zero,collectionViewLayout:flowLayout)
        collectionView?.showsHorizontalScrollIndicator = true
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        
        bottomView.isHidden = true
        bottomView.backgroundColor = UIColor.colorWithHexStringSwift("f5f8ff")
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("b3c9ff")
        originMoneyNum.font = UIFont.systemFont(ofSize: 12)
        backMoneyNum.font = UIFont.systemFont(ofSize: 12)
        payMoneyNum.font = UIFont.systemFont(ofSize: 12)
        
        configView()
        configlayout()
    }
    
    @objc func btnClick(_ sender: UIButton) {
        btnCallBack?(sender)
    }
    
    func configView() {
        appointName.textAlignment = NSTextAlignment.center
        money.textAlignment = NSTextAlignment.center
        indexLabel.textAlignment = NSTextAlignment.center
//        name.textAlignment = NSTextAlignment.center
        self.addSubview(headerViewBg)
        headerViewBg.addSubview(appointName)
        headerViewBg.addSubview(money)
//        headerViewBg.addSubview(iconBgView)
//        iconBgView.addSubview(icon)
//        iconBgView.addSubview(name)
        headerViewBg.addSubview(indexBg)
        indexBg.addSubview(indexLabel)
        indexBg.addSubview(leftBtn)
        indexBg.addSubview(rightBtn)
        self.addSubview(tableView)
        self.addSubview(collectionView ?? tableView)
        self.addSubview(bottomView)
        bottomView.addSubview(lineView)
        bottomView.addSubview(titleLab)
        bottomView.addSubview(originMoney)
        bottomView.addSubview(originMoneyNum)
        bottomView.addSubview(backMoney)
        bottomView.addSubview(backMoneyNum)
        bottomView.addSubview(payMoney)
        bottomView.addSubview(payMoneyNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configlayout() {
        headerViewBg.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(80)
        }
        appointName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.left.equalToSuperview()
        }
        money.snp.makeConstraints { (make) in
            make.top.equalTo(appointName.snp.bottom).offset(14)
            make.left.right.equalTo(appointName)
        }
//        iconBgView.snp.makeConstraints { (make) in
//            make.top.equalTo(money.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(name)
//        }
//        icon.snp.makeConstraints { (make) in
//            make.width.height.equalTo(75)
//            make.top.equalToSuperview().offset(15)
//            make.centerX.equalToSuperview()
//        }
//        name.snp.makeConstraints { (make) in
//            make.top.equalTo(icon.snp.bottom).offset(10)
//            make.right.equalToSuperview().offset(-15)
//            make.left.equalToSuperview().offset(15)
//            make.bottom.equalToSuperview()
//        }
//        indexBg.snp.makeConstraints { (make) in
//            make.top.equalTo(iconBgView.snp.bottom).offset(10)
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
        indexBg.snp.makeConstraints { (make) in
            make.top.equalTo(money.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        indexLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        leftBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(indexLabel)
            make.right.equalTo(indexLabel.snp.left).offset(-10)
            make.width.equalTo(7)
            make.height.equalTo(13)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(indexLabel)
            make.left.equalTo(indexLabel.snp.right).offset(10)
            make.width.height.equalTo(leftBtn)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerViewBg.snp.bottom)
            make.left.right.equalTo(headerViewBg)
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
            make.bottom.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(15)
        }
        originMoney.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-8)
        }
        originMoneyNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(originMoney)
            make.left.equalTo(originMoney.snp.right)
        }
        payMoney.snp.makeConstraints { (make) in
            make.bottom.equalTo(titleLab)
            make.left.equalTo(SCREENWIDTH / 2)
        }
        payMoneyNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(payMoney)
            make.left.equalTo(payMoney.snp.right)
        }
        backMoney.snp.makeConstraints { (make) in
            make.centerY.equalTo(originMoney)
            make.left.equalTo(payMoney)
        }
        backMoneyNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(backMoney)
            make.left.equalTo(backMoney.snp.right)
        }
    }
    
    func attributedString(number: String, string: String) -> NSMutableAttributedString {
        let peopleStr : NSMutableAttributedString = NSMutableAttributedString()
        let peopleStr1 = self.appendColorStrWithString(str: "\(number)", font: 12, color: UIColor.colorWithHexStringSwift("e60000"))
        let peopleStr2 = self.appendColorStrWithString(str: string, font: 12, color: color11)
        peopleStr.append(peopleStr1)
        peopleStr.append(peopleStr2)
        return peopleStr
    }
    func appendColorStrWithString(str: String, font: CGFloat, color: UIColor) -> NSAttributedString {
        let attStr = NSAttributedString.init(string: str, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: font),NSAttributedStringKey.foregroundColor:color])
        return attStr
    }

}
