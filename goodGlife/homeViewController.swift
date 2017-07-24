//
//  homeViewController.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/09.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import UIKit
import CoreData
class homeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var todo:[String] = []
    var goalTask:[String] = []
    var taskCategories:[String] = ["ToDo","目標"]
    
    var  lastGaul:String = ""
    var now = Date()
    
//    MARK:プロパティ
            @IBOutlet weak var tableView: UITableView!
            @IBOutlet weak var subtableView: UITableView!
            @IBOutlet weak var textField: UITextField!
            @IBOutlet weak var myLabel: UILabel!
    
    
    @IBAction func btn(_ sender: UIButton) {
        lastGaul = textField.text! as! String
        print(lastGaul)
        
        //        AppDelegateのインスタンスを用意しておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //        エンティティを操作するためのオブジェクト
        let viewContext = appDelegate.persistentContainer.viewContext
        //        ToDoエンティティオブジェクトを作成
        let GoodGLife = NSEntityDescription.entity(forEntityName: "GoodGLife", in: viewContext)
        //        ToDoエンティティにレコード(行)を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: GoodGLife!, insertInto: viewContext)
        //        追加したいデータ(txtTitleに入力された文字)のセット
            newRecord.setValue(textField.text!, forKey: "title")
            newRecord.setValue(Date(), forKey: "deta")
            //        レコード(行)の即時保存
            do{
                try viewContext.save()
            }catch{
            }
        myLabel.text = lastGaul
    }
    
    
    
    
    //    複数タイトルの表示
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1{
        return taskCategories[0]
            }else{
            return taskCategories[1]
        }
          }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
          return todo.count
        }else{
            return goalTask.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if tableView.tag == 1{
            print(indexPath.row)
            cell.textLabel?.text = todo[indexPath.row]
            return cell
        }else{
            cell.textLabel?.text = goalTask[indexPath.row]
            return cell
        }
    }
    
    
    func read(){
        todo = []
        //        AooDelegateを使う用意をしておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //        エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        //        どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        do{
             query.sortDescriptors = [NSSortDescriptor(key: "tododeta",ascending: false)]
            //        データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //        ループで一行ずつ表示
            for result : AnyObject in fetchResults {
                //                一行ずつのデータを取得する
                //                MARK:todoTextのアペンド
                var todoText:String = ""
                if result.value(forKey: "todotitle") == nil {
                    print("ToDoなし")
                }else{
                    todoText = result.value(forKey: "todotitle") as! String
                    todo.append(todoText)
                    
                }
            }
        }catch{
        }
    }
    
    
    func read1(){
             goalTask = []
    
        
        //        AooDelegateを使う用意をしておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //        エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        //        どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<Goal> = Goal.fetchRequest()
        do{
            query.sortDescriptors = [NSSortDescriptor(key: "goaldeta",ascending: false)]
            //        データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //        ループで一行ずつ表示
            for result : AnyObject in fetchResults {
                
                //                一行ずつのデータを取得する
                //                MARK:todoTextのアペンド
                var goal:String = ""
            
                if result.value(forKey: "goaltitle") == nil || result.value(forKey: "goaldetail") == nil {
                    print("goalTextなし")
                }else{
                    goal = result.value(forKey: "goaltitle") as! String
                    goalTask.append(goal)

                  
                }
            }
        }catch{
        }
    }
    
    
    
    func read2(){
        lastGaul = ""
        //        AooDelegateを使う用意をしておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //        エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        //        どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<GoodGLife> = GoodGLife.fetchRequest()
        do{
            //        データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //        ループで一行ずつ表示
            for result : AnyObject in fetchResults {
                //                一行ずつのデータを取得する
                //                MARK:todoTextのアペンド
                var titleText:String = ""
                if result.value(forKey: "title") == nil {
                    print("titleはからです")
                }else{
                     titleText = result.value(forKey: "title") as! String
                    lastGaul = titleText
                    myLabel.text = titleText
                    
                }
            }
        }catch{
        }
    }
    
    
    
    
    
        
    @IBAction func back(_ sender: UITextField) {
    }
    
    
       override func viewWillAppear(_ animated: Bool) {
        // CoreDataからデータをfetchしてくる
        read()
        read1()
        read2()
        tableView.reloadData()
        subtableView.reloadData()
    }
 

    override func viewDidLoad() {
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
