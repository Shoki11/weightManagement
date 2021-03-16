//
//  Load.swift
//  weightManagement
//
//  Created by cmStudent on 2021/03/15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol GetDataProtocol {
    
    func getData(dataArray:[PersonalData])
    
}

protocol GetRankProtocol {
    
    func getRankData(dataArray:[RankData])
    
}

class Load {
    
    // データベース
    let db = Firestore.firestore()
    
    var personalDataArray = [PersonalData]()
    
    var rankDataArray = [RankData]()
    
    //　LoadModelをController側でインスタンス化した時にgetDataProtocolにアクセスできる
    var getDataProtocol : GetDataProtocol?
    
    var getRankProtocol : GetRankProtocol?
    
    func loadMyRecordData(userID: String, yearMonth: String, day: String) {
        
        db.collection("Users").document(userID).collection(yearMonth).addSnapshotListener{(snapShot, error) in
            
            // 初期化
            self.personalDataArray = []
            
            // errorが起きたら終了
            if error != nil {
                
                return
                
            }
            
            // snapShotのdocuments(firebaseのyyyyMMからしたのドキュメンツを全て持ってくる)
            if let snapShotDoc = snapShot?.documents {
                
                // snapShotDocはfirebaseの(ddの部分になるので01日,02日とあるだけforで取ってくる)
                for doc in snapShotDoc {
                    
                    // docのdataとは01日だったら01日の(date, userID, userName, weightを全て取ってくる)
                    let data = doc.data()
                    
                    // userIDのkeyでuserIDを取ってきてuserNameのkeyでuserNameを取ってくる
                    if let userID = data["userID"] as? String, let userName = data["userName"] as? String, let weight = data["weight"] as? String, let date = data["date"] as? Double{
                        
                        let newPersonalData = PersonalData(userID: userID, userName: userName, weight: weight, date: date)
                        
                        self.personalDataArray.append(newPersonalData)
                        
                    }
                    
                }
                
            }
            
            self.getDataProtocol?.getData(dataArray: self.personalDataArray)
            
        }
        
    }
    
    func loadRankingData(userID: String) {
        
        var rankNumber = 0
        
        var doneNumber = Int()
        
        db.collection("RankingData").order(by: "resultWeight").addSnapshotListener{
            
            (snapShot, error) in
            
            // 配列の中身が増えていくので初期化する
            self.rankDataArray = []
            
            if error != nil {
                
                return
                
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    
                    if let userID = data["userID"] as? String, let userName = data["userName"] as? String, let resultWeight = data["resultWeight"] as? String {
                        
                        let newRankData = RankData(userName: userName, resultWeight: resultWeight, userID: userID)
                        
                        self.rankDataArray.append(newRankData)
                        
                        rankNumber = rankNumber + 1
                        
                        if newRankData.userID == Auth.auth().currentUser?.uid {
                            
                            doneNumber = rankNumber
                            
                        }
                        
                    }
                    
                }
                
            }
            
            self.getRankProtocol?.getRankData(dataArray: self.rankDataArray)
            
        }
        
    }
    
}

