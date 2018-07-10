//
//  UploadPicturesTool.swift
//  Project
//
//  Created by wy on 2017/11/26.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
enum UploadPictureType: String {
    case userHeaderImage = "userHeaderImage"
    
}
class UploadPicturesTool: NSObject, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    let tenxunAppid = "1252043302"
    let tenxunAppKey = "2ae4806abe0f1ae393564456ff1130b5"
    let bukey: String = "hilao"
    let regin: String = "bj"
   
    
    override init() {
        super.init()
    }
    let pickVC = UIImagePickerController.init()
    weak var current: UIViewController?
    func changeHeadPortrait() {
        
        pickVC.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        pickVC.delegate = self
        pickVC.allowsEditing = true
        current?.present(pickVC, animated: true, completion: nil)
    }
    
    var finished: ((UIImage?) -> ())?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var photoImage: UIImage?
        if picker.sourceType == UIImagePickerControllerSourceType.camera {
            if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
                photoImage = photo
            }
        }
        if picker.sourceType == UIImagePickerControllerSourceType.savedPhotosAlbum {
            if let photo = info[UIImagePickerControllerEditedImage] as? UIImage {
                photoImage = photo
            }
        }
        self.finished?(photoImage)
        self.pickVC.dismiss(animated: true, completion: nil)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // **********************  zhangkaiqiang  *******************
        picker.dismiss(animated: true, completion: nil)
        // **********************************************************
//        mylog("取消")
    }
    
  
    
    
    ///保证上传的照片的方向和预想的方向一致
    func fixOrientation(image: UIImage) -> UIImage {
        if image.imageOrientation == UIImageOrientation.up {
            return image
        }
        var transform = CGAffineTransform.identity
        switch image.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch image.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored, UIImageOrientation.rightMirrored:
            ctx?.draw(image.cgImage!, in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        default:
            ctx?.draw(image.cgImage!, in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        }
        let cgimg = ctx!.makeImage()
        let img = UIImage.init(cgImage: cgimg!)
        
        
        return img
        
    }
    
}
