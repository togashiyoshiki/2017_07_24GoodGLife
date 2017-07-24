//
//  DailyShowViewController.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/04.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import UIKit
import CoreData
import Photos

class DailyShowViewController: ViewController {
    //MARK:プロパティ
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myView: UITextView!
    @IBOutlet weak var myimg: UIImageView!
    @IBOutlet weak var mytime: UILabel!
    
    
    var mytitle = ""
    var myDetail = ""
    var myDeta = ""
    var time = ""
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //グラデーションの開始色
        let topColor = UIColor(red:0.07, green:0.50, blue:0.26, alpha:1)
        //グラデーションの終了色
        let bottomColor = UIColor(red:0.54, green:1.00, blue:0.74, alpha:1)
        
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.view.bounds
        
        //グラデーションレイヤーをビューの一番下に配置
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        myLabel.text = mytitle
        myView.text = myDetail
        mytime.text = time
        if myDeta != nil {
            let strURL = myDeta
            if strURL != "no_image.jpg"{
                let url = URL(string: strURL as String!)
                
                var options:PHImageRequestOptions = PHImageRequestOptions()
                options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
                
                let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
                let manager: PHImageManager = PHImageManager()
                manager.requestImage(for: asset,targetSize: PHImageManagerMaximumSize,contentMode: .aspectFit,options: options) { (image, info) -> Void in
                    
                    if image != nil{
                    self.myimg.image = image
                        print("イメージは\(image)")
                    }
                }
            }
        }else{
            myimg.image = UIImage(named:"no_image.jpg")

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
