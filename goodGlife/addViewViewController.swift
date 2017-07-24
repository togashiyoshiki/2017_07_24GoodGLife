//
//  addViewViewController.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/13.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import UIKit

class addViewViewController: UIViewController {
    var ChoiceView = ""
    
//    左画像
    @IBOutlet weak var view1: UIImageView!
    @IBOutlet weak var view2: UIImageView!
    @IBOutlet weak var view3: UIImageView!

    
    //    左画像
    @IBAction func btn1(_ sender: UIButton) {
        view1.image = UIImage(named: "1.png")
        
        
    }
    @IBAction func btn2(_ sender: UIButton) {
        view2.image = UIImage(named: "1.png")
                    
    }
    @IBAction func btn3(_ sender: UIButton) {
        view2.image = UIImage(named: "ToDo.png")
//                    myDefault.set("ON", forKey: "FirstFlag")
//                    myDefault.synchronize()
    }
        
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
