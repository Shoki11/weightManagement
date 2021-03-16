//
//  ViewController.swift
//  weightManagement
//
//  Created by cmStudent on 2021/03/15.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var height: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    /// 余白を触ったらキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        userName.resignFirstResponder()
        height.resignFirstResponder()
        
    }
    

    @IBAction func done(_ sender: Any) {
        
        if userName.text?.isEmpty != true && height.text?.isEmpty != true {
            
            // signInAnonymouslyとは匿名のサインイン。ユーザーを作成するか
            // result か error が返ってくる
            Auth.auth().signInAnonymously { (result, error) in
                
                // 値が入ってたらここが呼ばれる
                
                if error != nil {
                    
                    print(error.debugDescription)
                    
                } else {
                    
                    UserDefaults.standard.setValue(self.userName.text, forKey: "userName")
                    UserDefaults.standard.setValue(self.height.text, forKey: "height")
                    
                    // アプリ内に保存できたら画面遷移
                    // tabVCのインスタンス化
                    let tabVC = self.storyboard?.instantiateViewController(identifier: "tabVC") as! TabViewController
                    
                    self.navigationController?.pushViewController(tabVC, animated: true)
                    
                }
                
            }
            
        }
        
    }

}

