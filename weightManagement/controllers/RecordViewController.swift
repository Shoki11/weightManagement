//
//  RecordViewController.swift
//  weightManagement
//
//  Created by cmStudent on 2021/03/15.
//

import UIKit

class RecordViewController: UIViewController {
    
    var getBetterWeight = GetBetterWeight()
    var sendDB = sendToFireBase()
    var alert = Alert()
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var inputWeight: UITextField!
    @IBOutlet weak var betterWeight: UILabel!
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        recordButton.isEnabled = false

        // 今日の日付 20010921で返される
        date.text = GetDate.getTodayDate(slash: false)
        
        betterWeight.text = "\(getBetterWeight.calcBetterWeight()) kg"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ナビゲーションバーを隠す
        //self.navigationController?.isNavigationBarHidden = true
        
    }
    
    /// 余白を触ったらキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        inputWeight.resignFirstResponder()
        
        recordButton.isEnabled = true
        
    }
    
    
    @IBAction func record(_ sender: Any) {
        
        // firebaseの中にユーザーの名前、体重、日付などを入れる
        sendDB.sendTodayWeightToDB(userName: GetUserData.getUserData(key: "userName"), weight: inputWeight.text!)
        
        // アラート
        alert.showAlert(title: "保存完了", message: "", buttonTitle: "OK", viewController: self)
        
    }
    
    
    ///
    
    
    ///
}
