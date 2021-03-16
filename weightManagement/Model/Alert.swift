//
//  Alert.swift
//  weightManagement
//
//  Created by cmStudent on 2021/03/15.
//

import Foundation
import EMAlertController

class Alert {
    
    func showAlert(title: String, message: String, buttonTitle: String, viewController: UIViewController) {
        
        let alert = EMAlertController(title: title, message: message)
        
        let close = EMAlertAction(title: buttonTitle, style:.cancel)
        
        // alertの角丸
        alert.cornerRadius = 10.0
        
        // icon画像
        alert.iconImage = UIImage(named: "ok")
        
        // 閉じる
        alert.addAction(close)
        
        // 受け取ったviewControllerにアラートを表示する
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
}
