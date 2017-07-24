
import UIKit
import CoreData
import Photos

class DailyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var myTitle:[String] = []
    var myDetail:[String] = []
    var myDeta:[String] = []
    var myImage:[String] = []
    var taskCategories:[String] = ["日記"]
    @IBOutlet weak var textView: UITableView!
    
    //    MARK:テーブルビューの作成
    
    //    複数タイトルの表示
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskCategories[0]//[section]
    }

    @IBOutlet weak var tableView: UITableView!
    //    ⑵行数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTitle.count
    }
    
    //    ⑶リストに表示する文字列を決定し、表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! CustomTableViewCell
        
        cell.myTitleLabel.text = myTitle[indexPath.row]
        cell.myDescriptionLabel.text = myDetail[indexPath.row]
        cell.myTime.text = myDeta[indexPath.row]
        
        let strURL = myImage[indexPath.row]
        
    
        
        
        if strURL != "no_image.jpg"{
            let url = URL(string: strURL as String!)
            var options:PHImageRequestOptions = PHImageRequestOptions()
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.fastFormat
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 10000, height: 10000),contentMode: .aspectFill,options: options) { (image, info) -> Void in
                cell.myImageView.image = image
            }
        }else{
            cell.myImageView.image = UIImage(named:"no_image.jpg")
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    //    セグエの設定　設定したセグエの名前を記入
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        どこのセグのどの値をと聞いている↓
        performSegue(withIdentifier: "Segue", sender: indexPath.row)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        guestの中身segueに飛んだSecondViewControllerクラスの継承している
        if (segue.identifier == "Segue") {
           let guest = segue.destination as! DailyShowViewController

            guest.mytitle = myTitle[sender! as! Int ]  as! String
            guest.myDetail = myDetail[sender as! Int] as! String
            guest.myDeta = myImage[sender as! Int]  as! String
            guest.time = myDeta[sender as! Int]  as! String
            
        }
    }
    
    
    
    
    //    データを取ります。
    func read(){
        //        カラの配列を用意します。
        myTitle = []
        myDetail = []
        myDeta = []
        myImage = []
        //        AppDelegateを使う準備
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //        エンティティを操作するためのオブジェクト
        let viewContext = appDelegate.persistentContainer.viewContext
        //        どのエンティティからデータを取得してくるか設定
        let query: NSFetchRequest<Daily> = Daily.fetchRequest()
        
        do{
            query.sortDescriptors = [NSSortDescriptor(key: "deilyDeta",ascending: false)]
            //            データを一括取得
            let fetchResults = try viewContext.fetch(query)
            //            データの取得
            for result: AnyObject in fetchResults {
                let title: String! = result.value(forKey: "dailyTitle") as! String
                let detail: String! = result.value(forKey: "dailyDetail") as! String
                let deta: NSDate! = result.value(forKey: "deilyDeta") as! NSDate
                let Img:String!  = result.value(forKey: "dailyImage") as! String
                
                //                print("imgの中身は:\(Img)")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                //Stringにしたい
                let detastring:String = formatter.string(from: deta as Date)
                
                if title == "" || title == nil || detail == "" || detail == nil{
                    print("空かnilです")
                }else{
                    //                    MARK:ここオプショナルになるなぜ？
                    print("titleは:\(title)detailは:\(detail)")
                    myTitle.append(title!)
                    myDetail.append(detail!)
                    myDeta.append(detastring)
                    
                }
                
                if Img == "" || Img == nil{
                    print("画像でいたはカラです。")
                }else{
                    myImage.append(Img)
                }
            }
        }catch{
        }
    }
    //    削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myTitle.remove(at: indexPath.row)
            print(myTitle)
            myDetail.remove(at: indexPath.row)
            print(myDetail)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //        AooDelegateを使う用意をしておく
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            //        エンティティを操作するためのオブジェクトを作成
            let viewContext = appDelegate.persistentContainer.viewContext
            //        どのエンティティからデータを取得してくるか設定
            let query:NSFetchRequest<Daily> = Daily.fetchRequest()
            do{
                //            削除するデータを取得
                let fetchResults = try viewContext.fetch(query)
                //            削除するデータを取得
                for result : AnyObject in fetchResults {
                    let deta: NSDate! = result.value(forKey: "deilyDeta") as! NSDate
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                    //Stringにしたい
                    let detastring:String = formatter.string(from: deta as Date)
                    
                    if detastring == myDeta[indexPath.row]{
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
    override func viewWillAppear(_ animated: Bool) {
        // CoreDataからデータをfetchしてくる
        read()
        self.tableView.reloadData()
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
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
