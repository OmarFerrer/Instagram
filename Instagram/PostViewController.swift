//
//  PostViewController.swift
//  Instagram
//
//  Created by bc0067042 on 2016/06/13.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {
    
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!

    //投稿ボタン
    @IBAction func hundlePostButton(sender: AnyObject) {
        let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
        
        //imageviewから画像取得
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
        
        //NSUserDefaultから表示名を取得
        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        
        //時間を取得
        let time = NSDate.timeIntervalSinceReferenceDate()
        
        //辞書を作成してFirebaseに保存
        let postData = ["caption": textField.text!, "image": imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength), "name": name, "time": time]
        postRef.childByAutoId().setValue(postData)
        
        //HUDで投稿完了を表示
        SVProgressHUD.showSuccessWithStatus("投稿しました")
        
        //すべてのモーダルを閉じる
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func hundleCancelButton(sender: AnyObject) {
        //画面を閉じる
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //受け取ったイメージを設定
        imageView.image = image
    }
}
