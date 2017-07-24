
import UIKit
import CoreData

class ToDo_GoalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK:プロパティ
    var todoTask:[String] = []
      var todoDeta:[String] = []
    
     var myDeta:[String] = []
    var goalTask:[String] = []
    var goalTaskDetail:[String] = []
    var taskCategories:[String] = ["ToDo","目標"]
   
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var subTableView: UITableView!
    
    
    
    //   MARK:メソッド
    //    MARK:メインセグメントの切り替え(ToDo&目標)
    @IBAction func mainSegument(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            mainView.isHidden = false
            subView.isHidden = true
            self.navigationItem.title = "ToDo"
        }else{
            mainView.isHidden = true
            subView.isHidden = false
            self.navigationItem.title = "目標"
        }
    }
    
    @IBAction func addToDo(_ sender: UIButton) {
        // テキストフィールド付きアラート表示
        let alert = UIAlertController(title: "ToDo", message: "文字を入力してください。", preferredStyle: .alert)
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    //        AppDelegateのインスタンスを用意しておく
                    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    //        エンティティを操作するためのオブジェクト
                    let viewContext = appDelegate.persistentContainer.viewContext
                    //        ToDoエンティティオブジェクトを作成
                    let ToDo = NSEntityDescription.entity(forEntityName: "ToDo", in: viewContext)
                    //        ToDoエンティティにレコード(行)を挿入するためのオブジェクトを作成
                    let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
                    //        追加したいデータ(txtTitleに入力された文字)のセット
                    if textField.text! == "" || textField.text! == nil{
                        print("nilが入っています。")
                    }else{
                        newRecord.setValue(textField.text!, forKey: "todotitle")
                        newRecord.setValue(Date(), forKey: "tododeta")
                    
                        
                        //        レコード(行)の即時保存
                        do{
                            try viewContext.save()
                        }catch{
                        }
                        print("右の文字が入る\(textField.text!)")
                        
                        
                        self.todoTask.append(textField.text!)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                        //Stringにしたい
                        let detastring:String = formatter.string(from: Date())

                        self.todoDeta.append(detastring)
                        self.TableView.reloadData()
                        
                    }
                }
            }
        })
        alert.addAction(okAction)
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "テキスト"
        })
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    //    複数タイトルの表示
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1{
               return taskCategories[0]
        }else{
          return taskCategories[1]
        }
    }



    //    ⑵行数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            print(tableView.tag)
            return todoTask.count
        }else{
            print(tableView.tag)
                        return goalTask.count
//            return goalTaskDetail.count
        }
    }
    //    ⑶リストに表示する文字列を決定し、表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        //        文字を表示するセルの取得(セルの再利用)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        //        表示したい文字の設定
        if tableView.tag == 1{
            cell.textLabel?.text=todoTask[indexPath.row]
            return cell
        }else{
              cell.goalTitle?.text=goalTask[indexPath.row]
            cell.goalDetail?.text=goalTaskDetail[indexPath.row]
            cell.goalTime?.text=myDeta[indexPath.row]
            return cell
        }
    }
 
        //    削除機能
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
             if tableView.tag == 1{
                if editingStyle == .delete {
                    
//                    print("削除する文字は\(todoTask)")
//                    print("削除する文字は\(todoDeta)")
                    
                    
                    //        AooDelegateを使う用意をしておく
                    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    //        エンティティを操作するためのオブジェクトを作成
                    let viewContext = appDelegate.persistentContainer.viewContext
                    //        どのエンティティからデータを取得してくるか設定
                    let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
                    do{

                        //            削除するデータを取得
                        let fetchResults = try viewContext.fetch(query)
                        //            削除するデータを取得
                        for result : AnyObject in fetchResults {
                            let deta: NSDate! = result.value(forKey: "tododeta") as! NSDate
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                            //Stringにしたい
                            let detastring:String = formatter.string(from: deta as Date)
                            ///        一行ずつ削除
                            if detastring == todoDeta[indexPath.row]{
                                //        一行ずつ削除
                                let record = result as! NSManagedObject
                                viewContext.delete(record)
                            }
                        }
                        //            削除した状態を保存(処理の確定)
                        try viewContext.save()
                         todoTask.remove(at: indexPath.row)
                        todoDeta.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.TableView.reloadData()
                    }catch{
                    }
                }
             }else{
                if editingStyle == .delete {
    
                                        //        AooDelegateを使う用意をしておく
                    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    //        エンティティを操作するためのオブジェクトを作成
                    let viewContext = appDelegate.persistentContainer.viewContext
                    //        どのエンティティからデータを取得してくるか設定
                    let query:NSFetchRequest<Goal> = Goal.fetchRequest()
                    do{
                        //            削除するデータを取得
                        let fetchResults = try viewContext.fetch(query)
                        //            削除するデータを取得
                        for result : AnyObject in fetchResults {
    
                            let deta: NSDate! = result.value(forKey: "goaldeta") as! NSDate
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                            //Stringにしたい
                            let detastring:String = formatter.string(from: deta as Date)
                            //        一行ずつ削除
                            if detastring == myDeta[indexPath.row]{
                                //        一行ずつ削除
                                let record = result as! NSManagedObject
                                viewContext.delete(record)
                            }
                        }
                        //            削除した状態を保存(処理の確定)
                        try viewContext.save()
                        myDeta.remove(at: indexPath.row)
                        goalTask.remove(at: indexPath.row)
                        goalTaskDetail.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.subTableView.reloadData()
                    }catch{
                    }
                }
    
            }
        }
    
        func read(){
            todoTask = []
            todoDeta = []
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
                         let deta: NSDate! = result.value(forKey: "tododeta") as! NSDate
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                        //Stringにしたい
                        let detastring:String = formatter.string(from: deta as Date)
                        todoTask.append(todoText)
                        todoDeta.append(detastring)
                        
                        print("todotitleは:\(todoText)")
                        print("tododetaは:\(todoDeta)")
                    }
                }
                 }catch{
            }
    }
    
    func read1(){
         myDeta = []
         goalTask = []
         goalTaskDetail = []
        
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
                var goalText:String = ""
                var goaletail:String = ""//追加
                if result.value(forKey: "goaltitle") == nil || result.value(forKey: "goaldetail") == nil {
                    print("goalTextなし")
                    print("goalDetailなし")
                }else{
                    goalText = result.value(forKey: "goaltitle") as! String
                    goaletail = result.value(forKey: "goaldetail") as! String//追加
                    let deta: NSDate! = result.value(forKey: "goaldeta") as! NSDate
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                    //Stringにしたい
                    let detastring:String = formatter.string(from: deta as Date)
                    goalTask.append(goalText)
                    goalTaskDetail.append(goaletail)//追加
                    myDeta.append(detastring)
                    print("goalTitle:は\(goalText)")
                    print("goaletail:は\(goaletail)") //追加
                    print("myDeta:は\(myDeta)") //追加)
                }
            }
            }catch{
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // CoreDataからデータをfetchしてくる
        read()
        read1()
        self.TableView.reloadData()
        self.subTableView.reloadData()
    }
    //    MARK:初期設定メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
               mainView.isHidden = false
        subView.isHidden = true
        // タイトルをセット
        self.navigationItem.title = "ToDo"
        // フォント種をTime New Roman、サイズを10に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 15)!]
        
        
        //グラデーションの開始色
//        let topColor = UIColor(red:0.07, green:1.00, blue:0.26, alpha:1)
        //グラデーションの終了色
//        let bottomColor = UIColor(red:0.54, green:1.00, blue:0.74, alpha:1)

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
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
