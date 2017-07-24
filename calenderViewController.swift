
import UIKit
import CoreData

class calenderViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate{
//    todoTask.append(todoText)
//    todoDeta.append(detastring)
    
    var calenderDeta:String = ""
    
    var titleText:[String] = []
    var detailText:[String] = []
    var now:[Date] = []
    var targetdeta:[String] = []
    
//MARK:calender用の関数
//    var datesWithMultipleEvents = ["2017-07-08"]
    
//    var datesWithEvent = ["2017-07-03"]
     var fillSelectionColors = ["1970/07/01": UIColor.green]
    //MARK:プロパティ
    
    var datesWithMultipleEvents :[String] = []
    var datesWithEvent:[String] = []
//    var fillSelectionColors = [datesWithEvent]
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
//     @IBOutlet weak var animationSwitch: UISwitch!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()

//    データの取り出し
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
//        calenderの情報の取得
        
        calenderDeta = self.dateFormatter.string(from: date)
        print(calenderDeta)
        
        read()
        
        tableView.reloadData()
        
                if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let identifier = ["cell_month", "cell_week"][indexPath.row]
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.calenderTitle.text=titleText[indexPath.row] as! String
        cell.calenderDetail.text=detailText[indexPath.row] as! String
        
             return cell
        }
    
    
    //    削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            titleText.remove(at: indexPath.row)
            detailText.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            //        AooDelegateを使う用意をしておく
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            //        エンティティを操作するためのオブジェクトを作成
            let viewContext = appDelegate.persistentContainer.viewContext
            //        どのエンティティからデータを取得してくるか設定
            let query:NSFetchRequest<Calender> = Calender.fetchRequest()
            do{
                query.sortDescriptors = [NSSortDescriptor(key: "deta",ascending: false)]
                //            削除するデータを取得
                let fetchResults = try viewContext.fetch(query)
                //            削除するデータを取得
                for result : AnyObject in fetchResults {
                   var deta1 = result.value(forKey: "deta") as! Date
                    
                    if now[indexPath.row] == deta1{
                        //        一行ずつ削除
                        let record = result as! NSManagedObject
                        viewContext.delete(record)
                    }
                }
                //            削除した状態を保存(処理の確定)
                try viewContext.save()
            }catch{
            }
        }
    }
    
    
    
    @IBAction func addCalender(_ sender: UIBarButtonItem) {
        if calenderDeta == "" || calenderDeta == nil {
            print("カラです")
        }else{
        performSegue(withIdentifier: "Segue", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        guestの中身segueに飛んだSecondViewControllerクラスの継承している
        if (segue.identifier == "Segue") {
            let guest = segue.destination as! addCalenderViewController
            guest.nextdeta = calenderDeta
        }
    }
    
    
    func read(){
        titleText = []
        detailText = []
        targetdeta = []
        now = []
        //        AooDelegateを使う用意をしておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //        エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        //        どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<Calender> = Calender.fetchRequest()
        do{
            //        データの一括取得
            let fetchResults = try viewContext.fetch(query)
            //        ループで一行ずつ表示
            for result : AnyObject in fetchResults {
                //                一行ずつのデータを取得する
                //                MARK:todoTextのアペンド
                    var titleText1 =  result.value(forKey: "title") as! String
                    var detailText1 = result.value(forKey: "detail") as! String
                    var targetdeta1 = result.value(forKey: "targetdeta") as! String
                    var now1 = result.value(forKey: "deta") as! Date
                    
                //                    var now = result.value(forKey: "deta") as! String
//                    let deta: NSDate! = result.value(forKey: "tododeta") as! NSDate
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    Stringにしたい
//                    let detastring:String = formatter.string(from: deta as Date)
                
//                MARK:同じ日付の場合
                
                if calenderDeta == targetdeta1{
                    titleText.append(titleText1)
                    detailText.append(detailText1)
                    targetdeta.append(targetdeta1)
                    
                    now.append(now1)
                    print("titleTextは:\(titleText)")
                    print("tododetaは:\(detailText)")
                    print("targetdetaは:\(targetdeta)")
                }
                //MARK:追加
                
                var dateforEvent = targetdeta1.replacingOccurrences(of: "/", with: "-")
                datesWithEvent.append(dateforEvent)
                fillSelectionColors[targetdeta1] = UIColor.green
                print("datesWithEventは\(datesWithEvent)")
                print("fillSelectionColorsは\(fillSelectionColors)")
                
            }
        }catch{
        }
    }
    
    ///    MARK:calenderのポインターの作成
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        if self.datesWithMultipleEvents.contains(dateString) {
            return 3
        }
        return 0
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return UIColor.purple
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter2.string(from: date)
        if self.datesWithMultipleEvents.contains(key) {
            return [UIColor.magenta, appearance.eventDefaultColor, UIColor.black]
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillSelectionColors[key] {
            return color
        }
        return appearance.selectionColor
    }
    ///ここまでわかりません。
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // CoreDataからデータをfetchしてくる
        read()
        self.tableView.reloadData()
        calendar.reloadData()
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderDeta = self.dateFormatter.string(from: Date())
        read()
        calendar.reloadData()
        tableView.reloadData()
        
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
