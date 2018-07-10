//
//  DDCreateCommentVC.swift
//  Project
//
//  Created by WY on 2017/12/26.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCreateCommentVC: DDNormalVC {
    var addButton = UIButton(type: UIButtonType.contactAdd)
    var imagesContainer = UIView()
    var medias = [[String:String]]()
    
    var para :  (shop_id:String,shop_name:String ,classify_pid : String)!
    convenience init(para:(shop_id:String,shop_name:String ,classify_pid : String)){
        self.init()
        self.para = para
    }
    let textView = UITextView.init()
    //btn的isSelected属性为false 为选中了当前标签 , 五角星是实心
    var btns  = [UIButton]()
    let labelsContainer = UIView()
    var subviewsMaxY : CGFloat = 0
    let  subviewsX : CGFloat = 10
    var commentLabelsApiModle : DDCommentLabelsApiModle?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self._layoutsubviews()
        self.requestLabels()
        // Do any additional setup after loading the view.
    }
}

/// retuest
extension DDCreateCommentVC{
    func requestLabels() {
        DDRequestManager.share.getCommentLabels(classify_pid: self.para.classify_pid ,true )?.responseJSON(completionHandler: { (response ) in
            let decoder = JSONDecoder.init()
            do{
                let commentLabelsApiModel = try decoder.decode(DDCommentLabelsApiModle.self , from: response.data ?? Data())
                self.commentLabelsApiModle = commentLabelsApiModel
                self.configLabels()
                
                self.layoutTextField()
                mylog(commentLabelsApiModel.data)
            }catch{
                mylog(error)
            }
            
            
            mylog(response.value)
        })
    }

}

/// actions
extension DDCreateCommentVC{
    
    @objc func sendClick(sender:UIButton)  {
        mylog("sendClick")
        var score  = 0
        
        for btn  in btns {
            if !btn.isSelected{score += 1}
        }
        let encoder = JSONEncoder.init()
        var jsonStr = ""
        do {
            let result = try encoder.encode(medias)
            jsonStr = String.init(data: result , encoding: String.Encoding.utf8) ?? ""
        }catch{
            
        }
    
        let imagesJsonCode = jsonStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        DDRequestManager.share.writeComment(parametes: (shop_id: para.shop_id, shop_name: para.shop_name, content: self.textView.text ?? "" , is_img: 0, images: imagesJsonCode , type: 1, score: score),true )?.responseJSON(completionHandler: { (response ) in
        })
    }
    @objc func addClick(sender:UIButton)  {
        mylog("addClick")
        chooseMediaType()
        
    }
    
    @objc func startSelect(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        let tag = sender.tag
        if sender.isSelected {
            for index  in tag..<btns.count  {
                btns[index].isSelected = sender.isSelected
            }
        }else{
            for index  in 0...tag  {
                btns[index].isSelected = sender.isSelected
            }
        }
    }
    @objc func imageDelete(sender:UIButton){
        mylog(sender.superview?.tag)
        if let imgItem = sender.superview {
            imgItem.removeFromSuperview()
            layoutImages(nil)
        }
    }
}
/// layout ui
extension DDCreateCommentVC{
    
    func _layoutsubviews() {
        let btnWH : CGFloat = 25
        let leftBorder : CGFloat = subviewsX
        let rightBorder : CGFloat = subviewsX
        let topBorder: CGFloat = 10
        let margin : CGFloat = 3
        let label = UILabel()
        label.text = "认证点评很重要喔!"
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.DDSubTitleColor
        let Y : CGFloat = DDNavigationBarHeight + topBorder
        for index  in 0..<5 {
            let btn = UIButton.init(frame: CGRect.zero)
            btn.tag = index
            btn.addTarget(self , action: #selector(startSelect(sender:)), for: .touchUpInside)
            btn.setImage(UIImage(named:"star_fill"), for: UIControlState.normal)
            btn.setImage(UIImage(named:"star_empty"), for: UIControlState.selected)
            self.view.addSubview(btn)
            btns.append(btn)
            btn.frame = CGRect(x: leftBorder + (margin + btnWH) * CGFloat(index) , y: Y, width: btnWH, height: btnWH)
            if index == 4{
                //layout label
                self.view.addSubview(label)
                label.frame = CGRect(x: btn.frame.maxX + margin, y: Y, width: self.view.bounds.width - rightBorder - btn.frame.maxX - margin, height: btnWH)
            }
        }
        
        let grayLine = UIView(frame: CGRect(x: 0, y: topBorder + btnWH + topBorder + DDNavigationBarHeight, width: self.view.bounds.width , height: 2))
        subviewsMaxY = grayLine.frame.maxY
        self.view.addSubview(grayLine)
        grayLine.backgroundColor = UIColor.SeparatorColor
        self.view.addSubview(labelsContainer)
        self.view.addSubview(self.textView)
        //        self.textField.placeholder = "say your feeling"
        self.textView.backgroundColor = UIColor.DDLightGray
        let sendBtn = UIButton.init(frame: CGRect(x: subviewsX, y: self.view.bounds.height - 88, width: self.view.bounds.width - subviewsX  * 2, height: 44))
        self.view.addSubview(sendBtn)
        sendBtn.backgroundColor = mainColor
        sendBtn.setTitle(DDLanguageManager.text("send"), for: UIControlState.normal)
        sendBtn.addTarget(self , action: #selector(sendClick(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(imagesContainer)
        imagesContainer.addSubview(addButton)
        addButton.addTarget(self , action: #selector(addClick(sender:)), for: UIControlEvents.touchUpInside)
        addButton.backgroundColor = UIColor.randomColor()
    }
    
    
    func configLabels() {
        if let labels = self.commentLabelsApiModle?.data{
            for model in labels{
                let label = UILabel()
                label.textAlignment = NSTextAlignment.center
                label.backgroundColor = UIColor.SeparatorColor
                self.labelsContainer.addSubview(label)
                label.text = model.value
                label.ddSizeToFit()
            }
        }
        
        let leftRightPaddingMargin : CGFloat = 10
        let verticalMargin  :CGFloat = 10
        let labelMargin : CGFloat = 10
        let toTopMargin : CGFloat = 10
        var maxX : CGFloat = leftRightPaddingMargin
        var maxY : CGFloat = verticalMargin + toTopMargin
        var leftWidth : CGFloat = self.view.bounds.width - leftRightPaddingMargin * 2
        for (index , label) in self.labelsContainer.subviews.enumerated() {
            label.ddSizeToFit(contentInset: UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
            if leftWidth < label.bounds.width{
                maxX = leftRightPaddingMargin
                maxY += (label.bounds.height + verticalMargin)
                leftWidth = self.view.bounds.width - leftRightPaddingMargin * 2
                let labelH = label.bounds.height + 5
                var labelW = label.bounds.width
                if labelW >= leftWidth{labelW = leftWidth }
                mylog(self.view.bounds.width)
                mylog(leftRightPaddingMargin * 2 )
                mylog(leftWidth)
                mylog(self.view.bounds.width - leftRightPaddingMargin * 2)
                mylog(labelW)
                label.bounds = CGRect(x: 0, y: 0, width: labelW, height: labelH)
            }
            label.layer.cornerRadius = label.bounds.height/2
            label.layer.masksToBounds = true
            label.center = CGPoint(x: maxX + label.bounds.width/2, y: maxY)
            maxX += (labelMargin + label.bounds.width)
            leftWidth = (self.view.bounds.width - leftRightPaddingMargin) - maxX
            if index == self.labelsContainer.subviews.count - 1{
                let toBottomMargin : CGFloat = 10
                self.labelsContainer.frame = CGRect(x: 0, y:subviewsMaxY + toTopMargin, width: self.view.bounds.width, height: label.frame.maxY + toBottomMargin)
                self.subviewsMaxY = labelsContainer.frame.maxY
            }
        }
        
    }
    func layoutTextField() {
        textView.frame = CGRect(x: subviewsX, y: subviewsMaxY, width: self.view.bounds.width - subviewsX * 2, height: 100)
        let margin : CGFloat = 10
        let WH : CGFloat = (self.view.bounds.width - margin * 2  - subviewsX * 2 ) / 3
        layoutImages(nil )
        imagesContainer.frame = CGRect(x: 0, y: textView.frame.maxY + margin, width: self.view.bounds.width, height: WH)
    }
    func layoutImages(_ imageOptional:UIImage?) {
        if let image = imageOptional  {
            let button = DDCommentSelectedImg()
            button.addTarget(self , action: #selector(imageDelete(sender:)), for: UIControlEvents.touchUpInside)
            button.backgroundColor = UIColor.randomColor()
            let willBeInsetIndex = max(imagesContainer.subviews.count - 2 , 0)
            button.setImage(image , for: UIControlState.normal)
            imagesContainer.insertSubview( button, at: willBeInsetIndex)
        }
        if self.imagesContainer.subviews.count > 6 {
            self.addButton.isHidden = true
        }else{self.addButton.isHidden = false }
        let margin : CGFloat = 10
        let x = subviewsX
        let WH : CGFloat = (self.view.bounds.width - margin * 2  - subviewsX * 2 ) / 3
        
        for (index , subview) in imagesContainer.subviews.enumerated() {
            let row = Int(index / 3)
            let col = index % 3
            subview.frame = CGRect(x: x + (WH + margin ) * CGFloat(col), y: (WH + margin) * CGFloat(row) , width: WH, height: WH)
            if index == imagesContainer.subviews.count - 1{
                let oldFrame = imagesContainer.frame
                imagesContainer.frame = CGRect(x: oldFrame.minX , y: oldFrame.minY , width: oldFrame.width, height: subview.frame.maxY)
            }
        }
    }

    func setNavigationBar()  {
        
        self.title = para.shop_name
        self.navigationItem.titleView?.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
}









import MobileCoreServices
extension DDCreateCommentVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func chooseMediaType()  {
        let alertvc = UIAlertController.init(title: nil , message: nil , preferredStyle: UIAlertControllerStyle.actionSheet)
        let action1 = UIAlertAction.init(title: "相册", style: UIAlertActionStyle.default) { (action ) in
            
            self.getMedia(type: 0)
            alertvc.dismiss(animated: true , completion: nil )
            //            self.dealwithLocation()
        }
        let action2 = UIAlertAction.init(title: "相机", style: UIAlertActionStyle.default) { (action ) in
            self.getMedia(type: 1)
            alertvc.dismiss(animated: true , completion: nil )
        }
        alertvc.addAction(action1)
        alertvc.addAction(action2)
        
        self.present(alertvc, animated: true , completion: nil )
    }
    
    func getMedia(type:Int = 0)  {// // 0 :相册 , 1 , 相机
       
        let picker = UIImagePickerController.init()
        picker.delegate = self
        if type == 0{
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }else{
            //            GDAlertView.alert("摄像头不可用", image: nil , time: 2, complateBlock: nil)//摄像头专属
            picker.sourceType = UIImagePickerControllerSourceType.camera//这一句一定在下一句之前
        }
        picker.mediaTypes = [kUTTypeMovie as String , kUTTypeVideo as String , kUTTypeImage as String  , kUTTypeJPEG as String , kUTTypePNG as String]//kUTTypeMPEG4
        picker.allowsEditing = true ;
        picker.videoMaximumDuration = 12
        //        picker.showsCameraControls = true//摄像头专属
        //        picker.cameraOverlayView = UISwitch()
        //        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        //            pickerVC.navigationBar.isHidden = true
        UIApplication.shared.keyWindow!.rootViewController!.present(picker, animated: true, completion: nil)
        //        UIApplication.shared.keyWindow!.rootViewController!.present(FilterDisplayViewController(), animated: true, completion: nil)//自定义照相机 , todo
    }
    
    // MARK: 注释 : imagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        mylog(info)
        if let type  = info[UIImagePickerControllerMediaType] as? String{
            mylog(type)
            picker.dismiss(animated: true) {}
            if type == "public.movie" {
                self.dealModie(info: info)
            }else if type == "public.image" {
                self.dealImage(info: info)
            }
        }
    }
    func dealModie(info:[String : Any])  {
        if let url  = info[UIImagePickerControllerMediaURL] as? URL {
            //file:///private/var/mobile/Containers/Data/Application/6142A42C-BDE9-43CF-8C2E-B04F06945925/tmp/51711806175__214B5E6E-8AD3-4AF0-9CA0-EF891A4B4543.MOV
            //                let avPlayer : AVPlayer = AVPlayer.init(url: url)
            //                let avPlayerVC : AVPlayerViewController  = AVPlayerViewController.init()
            //                self.avPlayerVC = avPlayerVC
            //                avPlayerVC.player = avPlayer
            //                self.present(avPlayerVC, animated: true  , completion: { })
            
            
            do{
                let data : Data = try Data.init(contentsOf: url)
                mylog(data)
                mylog(data.count)
                
                DispatchQueue.global().async {
                    let dataBase64 = data.base64EncodedString()
                    let size = dataBase64.characters.count
                    mylog(size)
                    
                }
            }catch{
                mylog(error)
            }
            
        }
    }
    
    
    func dealImage(info:[String : Any])  {
        
        var theImage : UIImage?
        if let editImageReal  = info[UIImagePickerControllerEditedImage] as? UIImage {
            layoutImages(editImageReal)
            theImage = editImageReal
            DDRequestManager.share.uploadMediaToTencentYun(image: editImageReal, progressHandler: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                    mylog("\(bytesWritten)---\(totalBytesWritten)---\(totalBytesExpectedToWrite)")
                
//                    {[type:1 , image:http , ]}
                // type 1 是图片 ,  2 是视频
            }, compateHandler: { (imageUrlInServer) in
                if let urlUnwrap = imageUrlInServer{
                    let dict = ["image_url":urlUnwrap , "type" : "1" , "video_url":""]
                    self.medias.append(dict)
                }
                mylog(imageUrlInServer)
            })
        }else{
            if let originlImage  = info[UIImagePickerControllerOriginalImage] as? UIImage {
                layoutImages(originlImage)
            }
        }
        
       
        
    }
    
    
    
    
    
}
