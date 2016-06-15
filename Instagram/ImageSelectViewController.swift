//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by bc0067042 on 2016/06/13.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate {
    
    @IBAction func handleLibraryButton(sender: AnyObject) {
        //ライブラリを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(pickerController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func handleCameraButton(sender: AnyObject) {
        //カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(pickerController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        //画面を閉じる
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            //撮影・選択された画像を取得
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //ここでpresentViewControllerを呼んでも表示されないのでメソッド終了してから呼ぶ
            dispatch_async(dispatch_get_main_queue()) {
                
                //AdobeImageEditorを起動
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.presentViewController(adobeViewController, animated: true, completion: nil)
            }
        }
        
        //閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //AdobeImageEditorが終わったら呼ばれる
    func photoEditor(editor: AdobeUXImageEditorViewController, finishedWithImage image: UIImage?) {
        //エディタを閉じる
        editor.dismissViewControllerAnimated(true, completion: nil)
        
        //投稿画面を開く
        let postViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Post") as! PostViewController
        postViewController.image = image
        presentViewController(postViewController, animated: true, completion: nil)
    }
    
    //ImageEditorでキャンセルされたら呼ばれる
    func photoEditorCanceled(editor: AdobeUXImageEditorViewController) {
        //エディタを閉じる
        editor.dismissViewControllerAnimated(true, completion: nil)
    }
}
