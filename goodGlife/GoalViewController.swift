//
//  GoalViewController.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/06/30.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import UIKit
import CoreData
class GoalViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    @IBAction func addBtn(_ sender: UIButton) {
        let taskName = textField.text
        let task = textView.text
        //        let taskView = textView.text
        //        条件追加でから文字を指定できる
        //            画面戻ります
        print("文字が入力された")
        let storyboard: UIStoryboard = self.storyboard!
    
        if taskName == "" || taskName == nil  {
            textField.placeholder = "文字が入力されていません"
            print("文字が入力されていない")
        }else if  task == "" || task == nil {
            print("文字が入力されていない")
        }else{
            // context(データベースを扱うのに必要)を定義。
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            // (データベースのエンティティです)型オブジェクトを代入します。
            let goal = Goal (context: context)
            let myTime = Date()
            goal.goaltitle = taskName!
            goal.goaldetail = task!
            goal.goaldeta  = myTime as NSDate

            print("タイトルは:\(goal.goaltitle!)")
            print("詳細は\(goal.goaldetail!)")
            print("時間は\(goal.goaldetail!)")
              self.dismiss(animated: true, completion: nil)
            // 上で作成したデータをデータベースに保存します。
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    
    //    戻るボタン
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeKeybord()
        
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
