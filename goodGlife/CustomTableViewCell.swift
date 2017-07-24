//
//  CustomTableViewCell.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/06/30.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    /// イメージを表示するImageView
    @IBOutlet weak var myImageView: UIImageView!
    /// タイトルを表示するLabel
    @IBOutlet weak var myTitleLabel: UILabel!
    /// 説明を表示するLabel
    @IBOutlet weak var myDescriptionLabel: UILabel!
    ///時間の表示するLabel
    @IBOutlet weak var myTime: UILabel!
    
    
    @IBOutlet weak var goalTitle: UILabel!
//    @IBOutlet weak var goalDetail: UILabel!
    @IBOutlet weak var goalTime: UILabel!
    @IBOutlet weak var goalDetail: UITextView!
    
//calender用のカスタムセル
    @IBOutlet weak var calenderTitle: UILabel!
    @IBOutlet weak var calenderDetail: UITextView!
    
    
    
    
    
    
    
    
    
    //    目標タイトルの作成
    //    @IBOutlet weak var goalTitle: UILabel!
    //    詳細の作成
    //    @IBOutlet weak var goalDetail: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
