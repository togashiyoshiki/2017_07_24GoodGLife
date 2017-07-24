//
//  addCalenderViewController.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/12.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import UIKit

class addCalenderViewController: UIViewController {
//    MARK:プロパティ
    @IBOutlet weak var textLavel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    var nextdeta = ""
    var time = Date()
    
    //MARK:戻る
    @IBAction func back(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
        
    }
    //MARK:保存
    @IBAction func add(_ sender: UIButton) {
        let title = textField.text! as String
        let detail = textView.text! as String
        
        if title == "" || title == nil{
            self.textField.text = "タイトルを入力してください"
        }else if detail == "" || detail == nil{
            self.textView.text = "文字を入力してください"
        }else{
        
        // context(データベースを扱うのに必要)を定義。
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // taskにTask(データベースのエンティティです)型オブジェクトを代入します。
        let calender = Calender(context: context)
        
        calender.title=title
        calender.deta=time as NSDate
        calender.targetdeta=nextdeta
        calender.detail=detail
        print("titleは\(title)")
        print("detaは\(time)")
        print("nextdetaは\(nextdeta)")
        print("detail\(detail)")
        
        // 上で作成したデータをデータベースに保存します。
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.dismiss(animated: true, completion: nil)
        }
    }
    
//    MARK: back
    
    @IBAction func backAgein(_ sender: UITextField) {
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


        textLavel.text = nextdeta
        
        
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
        // Dispose of any resources that can be recreated.
    }
    

}
