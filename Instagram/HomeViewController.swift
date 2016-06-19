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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //要素が追加されたらArrayに追加してテーブル再表示
        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildAdded, withBlock: {snapshot in
            
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                //Postdataクラスを生成して受け取ったデータを設定
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        
//        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
//        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
//        tableView.rowHeight = UITableViewAutomaticDimension
//        
//        //要素が追加されたらArrayに追加してテーブル再表示
//        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildAdded, withBlock: {snapshot in
//            
//            if let uid = FIRAuth.auth()?.currentUser?.uid {
//                //Postdataクラスを生成して受け取ったデータを設定
//                let postData = PostData(snapshot: snapshot, myId: uid)
//                self.postArray.insert(postData, atIndex: 0)
//                
//                //テーブル再表示
//                self.tableView.reloadData()
//            }
//        })
//        
//        //要素が変更されたら当該データを削除後追加して再表示
//        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildChanged, withBlock: {snapshot in
//            
//            //Postdataクラスを生成して受け取ったデータを設定
//            if let uid = FIRAuth.auth()?.currentUser?.uid {
//                let postData = PostData(snapshot: snapshot, myId: uid)
//                
//                //保持している配列から同じIDを探す
//                var index: Int = 0
//                for post in self.postArray {
//                    if post.id == postData.id{
//                        index = self.postArray.indexOf(post)!
//                        break
//                    }
//                }
//                
//                //差し替えるため一度削除
//                self.postArray.removeAtIndex(index)
//                
//                //更新済データを登録
//                self.postArray.insert(postData, atIndex: index)
//                
//                //当該セルのみ再表示
//                let indexPath = NSIndexPath(forRow: index, inSection: 0)
//                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//            }
//        })
//        
//        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostTableViewCell
        cell.postData = postArray[indexPath.row]
        
        //セル内ボタンのアクションをソースコードで設定
        cell.likeButton.addTarget(self, action: #selector(self.handleButton), forControlEvents: UIControlEvents.TouchUpInside) //★この記述の意味？
        //UILabelの行数が変わっている可能性があるので再描画
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //auto layoutを使ってセルの高さを動的に変化
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //セルがタップされたら何もせずに選択状態を解除
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //セル内ボタンタップ時のメソッド
    func handleButton(sender: UIButton, event:UIEvent){
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            
            if postData.isLiked {
                //すでにいいねをしていたらIDを取り除く
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        //削除するためにインデックスを保持
                        index = postData.likes.indexOf(likeId)!
                        break
                    }
                }
                postData.likes.removeAtIndex(index)
            } else {
                postData.likes.append(uid)
            }
            
            let imageString = postData.imageString
            let name = postData.name
            let caption = postData.caption
            let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
            let likes = postData.likes
            
            //辞書を作成してFirebaseに保存
            let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes]
            let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
            postRef.child(postData.id!).setValue(post)
            
        }
    }
    
}

