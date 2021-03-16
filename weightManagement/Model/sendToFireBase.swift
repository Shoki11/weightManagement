//
//  sendToFireBase.swift
//  weightManagement
//
//  Created by cmStudent on 2021/03/15.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class sendToFireBase {
    
    // +コレクションを開始のとこまでのパスができた
    let db = Firestore.firestore()
    
    // 今日の体重をデータベースに送る
    func sendTodayWeightToDB(userName: String, weight: String) {
        
        // 現在時刻を取得
        // /で区切って2001/01/23のように 0番目は2001 1番目は01
        var date = GetDate.getTodayDate(slash: true)
        
        // 現在の年月をcollectionIDとして
        for _ in 0 ... 1 {
            
            // dateの中に/があったら""に置き換える
            if let slash = date.range(of: "/") {
                
                date.replaceSubrange(slash, with: "")
                
                print(date)
                
            }
            
        }
        
        // 20010123 前から6つ 200101をcollectionIDに
        let collectionID = date.prefix(6)
        
        // 20010123 後ろから2つ 23をdocumentIDnに
        let documentID = date.suffix(2)
        
        
        
        // 現在の日をドキュメントIDとして
        // 初めてアプリを立ち上げた時
        if UserDefaults.standard.object(forKey: "today") != nil {
            
            
            
        } else {
            
            // 初めての時
            UserDefaults.standard.setValue(date, forKey: "today")
            UserDefaults.standard.setValue(1, forKey: "done")
            
        }
        
        // 今日はまだ送信していない
        if UserDefaults.standard.object(forKey: "today") as! String != date {
            
            db.collection("Users").document(Auth.auth().currentUser!.uid)
                .collection(String(collectionID))
                .document(String(documentID))
                .setData(
                    
                    ["userName": userName, "userID": Auth.auth().currentUser!.uid, "weight": weight, "date": Date().timeIntervalSince1970]
                
                )
            
            UserDefaults.standard.setValue(date, forKey: "today")
            UserDefaults.standard.setValue(0, forKey: "done")
            
        } else if UserDefaults.standard.object(forKey: "today") as! String == date && UserDefaults.standard.object(forKey: "done") as! Int == 0 {
            
            
            
            // 今日は送信ずみ
            db.collection("Users").document(Auth.auth().currentUser!.uid)
                .collection(String(collectionID))
                .document(String(documentID))
                .updateData(["weight": weight])
            
            UserDefaults.standard.setValue(date, forKey: "today")
         
            // アプリを初めて立ち上げる時
        } else {
            
            db.collection("Users").document(Auth.auth().currentUser!.uid)
                .collection(String(collectionID))
                .document(String(documentID))
                .setData(
                    
                    ["userName": userName, "userID": Auth.auth().currentUser!.uid, "weight": weight, "date": Date().timeIntervalSince1970]
                
                )
            
            UserDefaults.standard.setValue(date, forKey: "today")
            UserDefaults.standard.setValue(0, forKey: "done")
            
        }
        
        // data
        
    }
    
    // 差分
    func sendResultWeightToDB(userName: String, weight: String) {
        
        // 現在時刻を取得
        // /で区切って2001/01/23のように 0番目は2001 1番目は01
        var date = GetDate.getTodayDate(slash: true)
        
        // 現在の年月をcollectionIDとして
        for i in 0 ... 1 {
            
            // dateの中に/があったら""に置き換える
            if let slash = date.range(of: "/") {
                
                date.replaceSubrange(slash, with: "")
                
                print(date)
                
            }
            
        }
        
        // 20010123 前から6つ 200101をcollectionIDに
        let collectionID = date.prefix(6)
        
        // 20010123 後ろから2つ 23をdocumentIDnに
        let documentID = date.suffix(2)
        
        
        
        // 現在の日をドキュメントIDとして
        
        // 初めてアプリを立ち上げた時
        if UserDefaults.standard.object(forKey: "today2") != nil {
            
            
            
        } else {
            
            // 初めての時
            UserDefaults.standard.setValue(date, forKey: "today2")
            UserDefaults.standard.setValue(1, forKey: "done2")
            
        }
        
        // 今日はまだ送信していない
        if UserDefaults.standard.object(forKey: "today2") as! String != date {
            
            db.collection("RankingData").document(Auth.auth().currentUser!.uid)
                .setData(
                    
                    ["userName": userName, "userID": Auth.auth().currentUser!.uid, "resultWeight": weight]
                
                )
            
            UserDefaults.standard.setValue(date, forKey: "today2")
            UserDefaults.standard.setValue(0, forKey: "done2")
            
        } else if UserDefaults.standard.object(forKey: "today2") as! String == date && UserDefaults.standard.object(forKey: "done2") as! Int == 0 {
            
            // 今日は送信ずみ
            db.collection("RankingData").document(Auth.auth().currentUser!.uid)
                .updateData(
                
                    ["userName": userName, "userID": Auth.auth().currentUser!.uid, "resultWeight": weight]
                    
                )
            
            UserDefaults.standard.setValue(date, forKey: "today2")
         
            // アプリを初めて立ち上げる時
        } else {
            
            db.collection("RankingData").document(Auth.auth().currentUser!.uid)
                .setData(
                    
                    ["userName": userName, "userID": Auth.auth().currentUser!.uid, "resultWeight": weight]
                
                )
            
            UserDefaults.standard.setValue(date, forKey: "today2")
            UserDefaults.standard.setValue(0, forKey: "done2")
            
        }
        
        // data
        
    }
    
}

