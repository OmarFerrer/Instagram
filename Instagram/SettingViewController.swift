//
//  SettingViewController.swift
//  Instagram
//
//  Created by bc0067042 on 2016/06/13.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleChangeButton(sender: AnyObject) {
        if let name = displayNameTextField.text {
            
            //表示名が入力されていない時はHUDを出して何もしない
            if name.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("表示名を入力してください")
                return
            }
            
            //Firebaseに表示名を保存する
            if let request = FIRAuth.auth()?.currentUser?.profileChangeRequest(){
                request.displayName = name
                request.commitChangesWithCompletion() { error in
                    if error != nil {
                        print(error)
                    } else {
                        //NSUserDefaultsに表示名を保存
                        let ud = NSUserDefaults.standardUserDefaults()
                        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
                        ud.synchronize()
                        
                        //HUDで完了を通知
                        SVProgressHUD.showSuccessWithStatus("表示名を変更しました")
                        
                        //キーボードを閉じる
                        self.view.endEditing(true)
                    }
                }
            }
        }
    }
    
    
    @IBAction func handleLogoutButton(sender: AnyObject) {
        
        //ログアウトする
        try! FIRAuth.auth()?.signOut()
        
        //ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(loginViewController!, animated: true, completion: nil)
        
        //ログイン画面から戻ってきた時のためにホーム画面を選択している状態にしておく
        let tabBarController = parentViewController as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NSuserDefaultsから表示名を取得してtextfieldに設定する
        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        displayNameTextField.text = name
    }
    
}
