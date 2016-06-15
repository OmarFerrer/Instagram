//
//  HomeViewController.swift
//  Instagram
//
//  Created by bc0067042 on 2016/06/13.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //要素が追加されたらArrayに追加してテーブル再表示
        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildAdded, withBlock: {snapshot in
            
            //Postdataクラスを生成して受け取ったデータを設定
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let postData = PostData(snapshot: snapshot, myId: uid)
                self.postArray.insert(postData, atIndex: 0)
                
                //テーブル再表示
                self.tableView.reloadData()
            }
        })
        
        //要素が変更されたら当該データを削除後追加して再表示
        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildChanged, withBlock: {snapshot in
            
            //Postdataクラスを生成して受け取ったデータを設定
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let postData = PostData(snapshot: snapshot, myId: uid)
                
                //保持している配列から同じIDを探す
                var index: Int = 0
                for post in self.postArray {
                    if post.id == postData.id{
                        index = self.postArray.indexOf(post)!
                        break
                    }
                }
                
                //差し替えるため一度削除
                self.postArray.removeAtIndex(index)
                
                //更新済データを登録
                self.postArray.insert(postData, atIndex: index)
                
                //当該セルのみ再表示
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
        })
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostTableViewCell
        cell.postData = postArray[indexPath.row]
        
        //セル内ボタンのアクションをソースコードで設定
        cell.likeButton.addTarget(self, action: "handleButton:event:", forControlEvents: UIControlEvents.TouchUpInside) //★この記述の意味？
    }
}
