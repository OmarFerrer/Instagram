//
//  ViewController.swift
//  Instagram
//
//  Created by bc0067042 on 2016/06/13.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) { //★なぜdidloadのままではダメなのか？都度ログイン状態を判定するため？
        super.viewWillAppear(animated)
        
        //ログイン判定
        if FIRAuth.auth()?.currentUser != nil{
            //ログイン時の処理
            setupTab()
        } else {
            //未ログインの処理
            //viewwillappear内でpresentviewcontrollerを呼んでもダメなのでその後実行
            dispatch_async(dispatch_get_main_queue()){
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginViewController!, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func setupTab(){
        
        //画像のファイル名を指定してタブコントローラーを作成
        let tabBarController = ESTabBarController(tabIconNames: [
            "home", "camera", "setting"])
        
        //背景色・選択時の色を設定
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96 , green: 0.91, blue: 0.87, alpha: 1)
        
        //作成したタブバーコントローラを親のViewコントローラに追加 ★この辺意味がわからない
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMoveToParentViewController(self)
        
        //タブをタップした時に表示するViewコントローラを設定
        let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("Home")
        let settingViewController = storyboard?.instantiateViewControllerWithIdentifier("Setting")
        
        tabBarController.setViewController(homeViewController, atIndex: 0)
        tabBarController.setViewController(settingViewController, atIndex: 2)
        
        //真ん中のタブはボタンとして扱う
        tabBarController.highlightButtonAtIndex(1)
        tabBarController.setAction({
            
            //ボタンが押されたらイメージViewコントローラをモーダル表示
            let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelect")
            self.presentViewController(imageViewController!, animated: true, completion: nil)
        }, atIndex: 1)
    }


}

