//
//  LoginViewController.swift
//  Instagram
//
//  Created by bc0067042 on 2016/06/13.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAdressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleLoginButton(sender: AnyObject) {
        if let adress = mailAdressTextField.text, let password = passwordTextField.text {
            //いずれかが未入力ならなにもしない
            if adress.characters.isEmpty || password.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必須項目を入力してください")
                return
            }
            
            //処理中を表示
            SVProgressHUD.show()
            
                    FIRAuth.auth()?.signInWithEmail(adress, password: password) {
                        user, error in
                        if error != nil {
                            //エラー表示
                            SVProgressHUD.showErrorWithStatus("エラー")
                            print(error)
                        } else {
                            //firebaseからユーザ表示名を取り出し
                            if let displayName = user?.displayName {
                                        //NSUserDefaultsに表示名を保存
                                        self.setDisplayName(displayName)
                            }
                                        //HUDを消す
                            SVProgressHUD.dismiss()
                            
                                        //画面を閉じる
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                }
                            }
                        }
    
    
    @IBAction func handleCreateAcountButton(sender: AnyObject) {
        if let adress = mailAdressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            //いずれかが未入力ならなにもしない
            if adress.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必須項目を入れてください")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            FIRAuth.auth()?.createUserWithEmail(adress, password: password){ //★ここの書き方の意味がわからない
                user, error in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus("エラー")
                    print(error)
                } else {
                    //ユーザ作成ができたらそのままログイン
                    FIRAuth.auth()?.signInWithEmail(adress, password: password) {
                        user, error in
                        if error != nil {
                            SVProgressHUD.showErrorWithStatus("エラー")
                            print(error)
                        } else {
                            if let user = user {
                                //firebase に表示名を保存
                                let request = user.profileChangeRequest()
                                request.displayName = displayName
                                request.commitChangesWithCompletion() { error in
                                    if error != nil{
                                        SVProgressHUD.showErrorWithStatus("エラー") //テキストになかったので足した
                                        print(error)
                                    } else {
                                        //NSUserDefaultsに表示名を保存
                                        self.setDisplayName(displayName)
                                        
                                        //HUDを消す
                                        SVProgressHUD.dismiss()
                                        
                                        //画面を閉じる
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDisplayName(name: String){
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
        ud.synchronize()
    }
}
