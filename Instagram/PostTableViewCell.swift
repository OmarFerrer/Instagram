//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by bc0067042 on 2016/06/15.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var commentLabel: UILabel!
    
    var postData: PostData!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //表示されるときに呼ばれるメソッドをオーバーライドしデータにUI反映
    override func layoutSubviews() {
        postImageView.image = postData.image
        captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        //ボタン識別のためのタグ追加
        likeButton.tag = 1
        commentButton.tag = 2
        //ここまで
        
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.stringFromDate(postData.date!)
        dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        }
        
        
        //コメントの表示を以下に入れる
        //コメントの数だけループ
        if postData.comments.count > 0 {
            var commentLabelString: String = ""
            for comment in postData.comments {
                commentLabelString = commentLabelString + " \n " + comment
            }
            commentLabel.text = commentLabelString
        } else {
            commentLabel.text = "" //なければ空
        }
        //ここまで
        
        super.layoutSubviews()
    }
}
