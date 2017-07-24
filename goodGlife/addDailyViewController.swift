//
//  addDailyViewController.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/02.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//
///参考資料
////    時間の取得
//    func getNowClockString() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd' " //'HH:mm:ss
//        let now = Date()
//        return formatter.string(from: now)
//    }

import UIKit
import CoreData
import Photos


class addDailyViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    //    プロパティ
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    //表示文字の変更
    @IBOutlet weak var mytitle: UILabel!
    @IBOutlet weak var mydetail: UILabel!
    
    
    //    ボタンが押された時の処置
    @IBAction func addBtn(_ sender: UIButton) {
        
        // TextFieldに何も入力されていない場合は何もせずに1つ目のビューへ戻ります。
        let myTitle = textField.text! as String
        let myDetail = textView.text! as String
        let myTime = Date()
    
        let myDefault = UserDefaults.standard
        // データを取り出す
        let strURL = myDefault.string(forKey: "selectedPhotoURL")
        
        print("URLは:\(strURL)")
        print(myTitle)
        print(myDetail)
        if myTitle == "" || myTitle == nil {
            mytitle.text="タイトルを入力してください"
        }else if myDetail == "" || myDetail == nil {
            mydetail.text="詳細を入力してください"
        }else if strURL == nil {
            
            // context(データベースを扱うのに必要)を定義。
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            // taskにTask(データベースのエンティティです)型オブジェクトを代入します。
            let daily = Daily(context: context)
            
            ///先ほど定義したTask型データのname、categoryプロパティに入力、選択したデータを代入します。
            
            imageView.image = UIImage(named: "no_image.jpg")
            
            print("テキストフィールドは\(myTitle)")
            print("テキストビューは\(myDetail)")
            print("テキストビューは\(myTime)")
            print("URLは\(strURL)")
            
            daily.dailyTitle = myTitle
            daily.dailyDetail = myDetail
            daily.deilyDeta = myTime as NSDate
            daily.dailyImage = "no_image.jpg"
            self.dismiss(animated: true, completion: nil)
        }else{
            // context(データベースを扱うのに必要)を定義。
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            // taskにTask(データベースのエンティティです)型オブジェクトを代入します。
            let daily = Daily(context: context)
            
            // 先ほど定義したTask型データのname、categoryプロパティに入力、選択したデータを代入します。
            print("テキストフィールドは\(myTitle)")
            print("テキストビューは\(myDetail)")
            print("テキストビューは\(myTime)")
            print("URLは\(strURL)")
            daily.dailyTitle = myTitle
            daily.dailyDetail = myDetail
            daily.deilyDeta = myTime as NSDate
            daily.dailyImage = strURL
            
             self.dismiss(animated: true, completion: nil)
            ///ユーザーデフォルトの削除
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "selectedPhotoURL")
        }
    
        // 上で作成したデータをデータベースに保存します。
     
        
      
    }
    
    @IBAction func addimg(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {    //追記
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
            let controller = UIImagePickerController()
            
            controller.delegate = self
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //トリミング
            controller.allowsEditing = true
            //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.present(controller, animated: true, completion: nil)
            //UserDefaultから取り出す
            // ユーザーデフォルトを用意する
            let myDefault = UserDefaults.standard
            
            // データを取り出す
            let strURL = myDefault.string(forKey: "selectedPhotoURL")
            
            
            
            
            if strURL != nil{
                let url = URL(string: strURL as String!)
                var options:PHImageRequestOptions = PHImageRequestOptions()
                options.deliveryMode = PHImageRequestOptionsDeliveryMode.fastFormat
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
                let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
                let manager: PHImageManager = PHImageManager()
                manager.requestImage(for: asset,targetSize: PHImageManagerMaximumSize,contentMode: .aspectFill,options: options) { (image, info) -> Void in
                    self.imageView.image = image
                }
            }
        }
    }
    
    //カメラロールで写真を選んだ後
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
        let strURL:String = assetURL.description
        print(strURL)
        // ユーザーデフォルトを用意する
        let myDefault = UserDefaults.standard
        // データを書き込んで
        myDefault.set(strURL, forKey: "selectedPhotoURL")
        // 即反映させる
        myDefault.synchronize()
        //閉じる処理
        
        
        if strURL != nil{
            let url = URL(string: strURL as String!)
            var options:PHImageRequestOptions = PHImageRequestOptions()
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.fastFormat
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: PHImageManagerMaximumSize,contentMode: .aspectFill,options: options) { (image, info) -> Void in
                self.imageView.image = image
            }
        }

        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //    戻るボタン
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //    キーボードの処理
    @IBAction func textFieldBack(_ sender: UITextField) {
    }
    func makeKeybord(){
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(GoalViewController.commitButtonTapped))
        
        kbToolBar.items = [spacer, commitButton]
        textView.inputAccessoryView = kbToolBar
    }
    func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
//    MARK: back
        
    @IBAction func backAgein(_ sender: UITextField) {
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeKeybord()
        
//        imageView.image = UIImage(named: "no_image.jpg")
        
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
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
